#!/bin/bash
echo "Deploying the odoo-cloud image to docker hub..."
docker tag odoo-cloud:latest odooexperts/odoo-cloud:latest
docker push odooexperts/odoo-cloud:latest