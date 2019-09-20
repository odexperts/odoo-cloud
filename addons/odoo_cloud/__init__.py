
from . import odoo_patches

# Apply Odoo Server Patches
odoo_patches.setup_redis_session_store()
odoo_patches.setup_db_attachment_storage()
