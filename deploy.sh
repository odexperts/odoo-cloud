#!/bin/bash
echo "Deploying the odoo-cloud image to docker hub..."
docker tag odoo-cloud:12 odooexperts/odoo-cloud:12
docker push odooexperts/odoo-cloud:12