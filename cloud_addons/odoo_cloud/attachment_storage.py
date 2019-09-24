
from odoo import api
from odoo.addons.base.models.ir_attachment import IrAttachment

# Override IrAttachment._storage function to use "db" as default storage


def setup():

    @api.model
    def _default_db_storage(self):
        return self.env['ir.config_parameter'].sudo().get_param('ir_attachment.location', 'db')

    IrAttachment._storage = _default_db_storage
