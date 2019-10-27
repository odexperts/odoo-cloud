FROM python:3.7-buster

# Set install dir
WORKDIR /usr/src/app

# Install Odoo dependencies
COPY odoo/requirements.txt ./
RUN set -x; \
  apt-get update \
  && curl -o wkhtmltox.deb -sSL https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.stretch_amd64.deb \
  && echo '7e35a63f9db14f93ec7feeb0fce76b30c08f2057 wkhtmltox.deb' | sha1sum -c - \
  && apt-get install -y --no-install-recommends \
  ./wkhtmltox.deb \
  python-dev libsasl2-dev libldap2-dev libssl-dev \
  && rm -rf /var/lib/apt/lists/* wkhtmltox.deb \
  && pip install --no-cache-dir -r requirements.txt

# Install Addon dependencies
COPY cloud_addons/requirements.txt ./cloud-requirements.txt
RUN pip install --no-cache-dir -r cloud-requirements.txt

# Create odoo user and directories and set permissions
RUN useradd -ms /bin/bash odoo \
  && mkdir odoo /etc/odoo /mnt/odoo /mnt/odoo/cloud_addons /mnt/odoo/data \
  /usr/src/app/scripts \
  && chown -R odoo:odoo odoo /etc/odoo /mnt/odoo

# Copy odoo source and config
COPY odoo ./odoo
COPY cloud_addons /mnt/odoo/cloud_addons
COPY src/entrypoint.sh ./
COPY src/scripts ./scripts
COPY src/odoo.conf /etc/odoo/
ENV PATH="/usr/src/app/scripts:${PATH}"

# Define runtime configuration
ENV ODOO_RC /etc/odoo/odoo.conf
USER odoo
EXPOSE 8069
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
CMD ["odoo"]