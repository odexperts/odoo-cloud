#!/bin/bash
set -x

# base image
docker run --rm -it -p 8069:8069 --env-file=./odoo.env odoo-cloud:13 $@

# with volume mounts
# docker run --rm -it -v $PWD/cloud_addons:/mnt/odoo/cloud_addons -v $PWD/odoo_data:/mnt/odoo/data -p 8069:8069 --env-file=./odoo.env odoo-cloud:13 $@
