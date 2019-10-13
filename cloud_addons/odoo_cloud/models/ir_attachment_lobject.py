
# Based on https://github.com/it-projects-llc/misc-addons/tree/12.0/attachment_large_object
# with tweaks to add dblo: to the start of the store_fname field

import logging
import base64
from odoo import models, api, SUPERUSER_ID, _
from odoo.exceptions import AccessError
import psycopg2

LARGE_OBJECT_LOCATION = 'dblo'
log = logging.getLogger(__name__)


class IrAttachment(models.Model):
    """Provide storage as PostgreSQL large objects of attachements with filestore location ``dblo``.

    Works by overriding the storage handling methods of ``ir.attachment``, as intended by the
    default implementation. The overrides call :funct:`super`, so that this is transparent
    for other locations.
    """

    _name = 'ir.attachment'
    _inherit = 'ir.attachment'

    @api.model
    def lobject(self, cr, *args):
        return cr._cnx.lobject(*args)

    def _is_dblo_attachment(self, fname):
        return fname and fname.startswith(LARGE_OBJECT_LOCATION + ':')

    @api.model
    def _file_write(self, value, checksum):
        """Write the content in a newly created large object.

        :param value: base64 encoded payload
        :returns str: object id (will be considered the file storage name)
        """
        location = self._storage()
        if location != LARGE_OBJECT_LOCATION:
            return super(IrAttachment, self)._file_write(value, checksum)

        lobj = self.lobject(self.env.cr, 0, 'wb')  # oid=0 means creation
        lobj.write(base64.b64decode(value))
        oid = lobj.oid
        return LARGE_OBJECT_LOCATION + ':' + str(oid)

    def _file_delete(self, fname):
        if self._is_dblo_attachment(fname):
            oid = int(fname[len(LARGE_OBJECT_LOCATION)+1:])
            return self.lobject(self.env.cr, oid, 'rb').unlink()
        else:
            return super(IrAttachment, self)._file_delete(fname)

    def _lobject_read(self, fname, bin_size):
        """Read the large object, base64 encoded.

        :param fname: file storage name, must be the oid as a string.
        """
        oid = int(fname[len(LARGE_OBJECT_LOCATION)+1:])
        lobj = self.lobject(self.env.cr, oid, 'rb')
        if bin_size:
            return lobj.seek(0, 2)
        # GR TODO it must be possible to read-encode in chunks
        return base64.b64encode(lobj.read())

    @api.depends('store_fname', 'db_datas')
    def _compute_datas(self):
        for attach in self:
            if self._is_dblo_attachment(attach.store_fname):
                bin_size = self._context.get('bin_size')
                attach.datas = self._lobject_read(attach.store_fname, bin_size)
            else:
                super(IrAttachment, attach)._compute_datas()

    @api.model
    def migrate_to_lobject(self):
        """migrates all binary attachments to postgres large object storage"""
        if not self.env.user._is_admin():
            raise AccessError(
                _('Only administrators can execute this action.'))

        atts = self.search([
            '&', '&',
            ('id', '>', 0),  # bypass filtering of field-attached attachments
            ('type', '=', 'binary'),
            '|',
            ('store_fname', '=', False), ('store_fname', 'not like', 'dblo:%')
        ])

        att_count = len(atts)
        if att_count:
            log.info(
                f'Migrating {att_count} database attachments to Large Objects...')
            if self._storage() != LARGE_OBJECT_LOCATION:
                raise Exception(
                    f'Default storage is not set to Large Object ({LARGE_OBJECT_LOCATION})')
            current_att = 1
            for att in atts:
                log.info(
                    f'Migrating attachment ID {att.id} ({current_att} of {att_count})...')
                # re-save data to move to lobject storage
                att.write({'datas': att.datas})
                current_att += 1
