#!/bin/bash
echo "Deploying the odoo-cloud image to docker hub..."
docker tag odoo-cloud:13 odooexperts/odoo-cloud:13
docker push odooexperts/odoo-cloud:13