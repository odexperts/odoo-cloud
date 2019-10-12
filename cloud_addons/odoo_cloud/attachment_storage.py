
from odoo import api, SUPERUSER_ID
from odoo.addons.base.models.ir_attachment import IrAttachment
import logging

log = logging.getLogger(__name__)


def setup():
    # Override IrAttachment._storage function to use "db" as default storage
    # (so we can boot without a filesystem)
    # then ir.config_parameter.xml is loaded to set default storage
    # to 'dblo' (PostgreSQL Large Object)

    log.info("Using Database attachment storage.")

    @api.model
    def _default_db_storage(self):
        return self.env['ir.config_parameter'].sudo().get_param('ir_attachment.location', 'db')

    IrAttachment._storage = _default_db_storage
