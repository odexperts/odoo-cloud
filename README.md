# Cloud-Native Odoo

This repository contains the source code for the `odoo-cloud` docker image,
which is designed to be used as a base image for cloud-native, production Odoo
deployments.

## Features

* Odoo 13, built from source
* Redis used for session storage
* Attachments stored in PostgreSQL Large Objects
* No writeable filesystem required

## Utilities

To extend this image for your own use. the following tools are available to be
used as part of your `Dockerfile`

```Dockerfile
# Override odoo config values
RUN odoo-config \
        addons_path+=,/mnt/odoo/my_custom_addons \
        addons_path+=,/mnt/odoo/more_addons \
        list_db=True
```

## Environment

This image supports the following environment variables

```bash
# PostgreSQL Connection Details
DB_HOST=host.docker.internal
DB_PORT=5432
DB_USER=odoo
DB_PASSWORD=odoo

# Redis Server
REDIS_HOST=host.docker.internal

# Extra Odoo CLI args
ODOO_EXTRA_ARGS= --db-filter=^%d$
```

## Building and Running the `odoo-cloud` image

### Building

* Checkout Odoo [source](https://github.com/odoo/odoo) into an `odoo` subdirectory
* Run `./build.sh`

### Running

* Make sure you have created an `odoo.env` file (based on `odoo.env-example`)
* `cd odoo-base && ./run.sh`

### Other Run Commands

You can pass any `odoo-bin` args via `run.sh`, e.g.:

```bash
# Initialise a new database (with demo data disabled)
./run.sh odoo -d db_name -i base --without-demo=all

# Run with a specific database
./run.sh odoo -d db_name

# Access the odoo shell for a specific database
./run.sh odoo-shell -d db_name

# Access bash inside the container
./run.sh bash
```

## TODO List

* Redis host from command line parameter

## Contributing

Contributions & Optimisations welcome! Please raise a pull request or issue.
