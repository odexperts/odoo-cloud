# Cloud-Native Odoo

This repository contains the source code for the `odoo-cloud` docker image,
which is designed to be used as a base of cloud-native, production Odoo
deployments.

## Features

* Odoo 12, built from source
* Redis used for session storage
* Files stored in PostgreSQL
* No writeable filesystem required

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

# Access bash inside the container
./run.sh bash
```

## Contributing

Contributions & Optimisations welcome! Please raise a pull request or issue!
