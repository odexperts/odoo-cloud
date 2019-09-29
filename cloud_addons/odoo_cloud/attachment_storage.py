
from odoo import api, SUPERUSER_ID
from odoo.addons.base.models.ir_attachment import IrAttachment


def setup():
    # Override IrAttachment._storage function to use "db" as default storage
    # (so we can boot without a filesystem)

    @api.model
    def _default_db_storage(self):
        return self.env['ir.config_parameter'].sudo().get_param('ir_attachment.location', 'db')

    IrAttachment._storage = _default_db_storage
