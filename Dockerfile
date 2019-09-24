FROM python:3.7-buster

# Update OS
RUN apt-get update && apt-get upgrade -y

# Set install dir
WORKDIR /usr/src/app

# Install Odoo dependencies
COPY odoo/requirements.txt ./
RUN apt-get install -y --no-install-recommends \
  python-dev libsasl2-dev libldap2-dev libssl-dev \
  && pip install --no-cache-dir -r requirements.txt

# Install Addon dependencies
COPY cloud_addons/requirements.txt ./cloud-requirements.txt
RUN pip install --no-cache-dir -r cloud-requirements.txt

# Create odoo user and directories and set permissions
RUN useradd -ms /bin/bash odoo \
  && mkdir odoo /etc/odoo /mnt/odoo /mnt/odoo/cloud_addons /mnt/odoo/addons /mnt/odoo/data \
  && chown -R odoo:odoo odoo /etc/odoo /mnt/odoo

# Copy odoo source and config
COPY odoo ./odoo
COPY cloud_addons /mnt/odoo/cloud_addons
COPY entrypoint.sh ./
COPY odoo.conf /etc/odoo/

# Define runtime configuration
ENV ODOO_RC /etc/odoo/odoo.conf
USER odoo
EXPOSE 8069
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
CMD ["odoo"]