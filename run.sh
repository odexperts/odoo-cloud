#!/bin/bash
set -x
docker run --rm -it -v $PWD/odoo-addons:/mnt/odoo/addons -v $PWD/odoo-data:/mnt/odoo/data -p 8069:8069 --env-file=./odoo.env odoo-cloud $@
