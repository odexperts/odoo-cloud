# Odoo Cloud Addons

Applies required customisations to Odoo Server so that it can be run
cloud-natively.

* Sessions stored in Redis
* Documents stored as Large Objects in PostgreSQL

## Migrating non-cloud-native databases

Before using databases with filesystem-based attachments in the cloud, you
can migrate them using the following code

```bash
./odoo-bin shell -d my_db
atts = env.get('ir.attachment')
atts.migrate_to_lobject()
env.cr.commit()
```

#### Potential subsequent data-fixes needed

The following fixes might be needed if odoo has not correctly set the MIME-type
of some migrated website data:

```
UPDATE ir_attachment SET mimetype = 'application/javascript' where url like '%.js';
UPDATE ir_attachment SET mimetype = 'text/css' where url like '%.css';
```