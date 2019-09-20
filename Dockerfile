FROM python:3.7-buster

# Update OS
RUN apt-get update && apt-get upgrade -y

# Set install dir
WORKDIR /usr/src/app

# Specify dependencies
COPY odoo/requirements.txt ./

# Install Dependencies
RUN apt-get install -y --no-install-recommends \
  python-dev libsasl2-dev libldap2-dev libssl-dev \
  && pip install --no-cache-dir -r requirements.txt

# Create odoo user and directories and set permissions
RUN useradd -ms /bin/bash odoo \
  && mkdir odoo /etc/odoo /mnt/odoo /mnt/odoo/addons /mnt/odoo/data \
  && chown -R odoo:odoo odoo /etc/odoo /mnt/odoo

# Copy odoo source and config
COPY odoo ./odoo
COPY entrypoint.sh ./
COPY odoo.conf /etc/odoo/

# Define runtime configuration
ENV ODOO_RC /etc/odoo/odoo.conf
USER odoo
EXPOSE 8069
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
CMD ["odoo"]