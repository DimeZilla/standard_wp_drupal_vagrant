# About
### author: Joshua Diamond <diamond.joshh@gmail.com>
### License: GNU GENERAL PUBLIC LICENSE
### Version: v2.0-beta

# What
Provides a linux command-line utility named `vagrant-create` for quickly creating vagrant projects.

# Why
I created this for me so that I could simply save my ideal vagrant setup for launching wordpress or drupal sites.

# Dependencies
- Requires a Vagrant installation.
- Linux - was written on Windows Subsystem Linux in Windows 10
     Note: You might have to install dos2unix and convert the line endings of some of these files
           if you try to run it in mac. not sure. Portability of this program is totally untested. Feel free to give it a shot and write me back or open an issue.

# Installation
View the releases tab to get a copy of the project.

```
chmod +x setup.sh
./setup.sh
```

# Usage
Now you can run create_dev anywhere and pass it a project name like so

## Simple
```
vagrant-create my-project
cd my-project
vagrant up
```

## Advanced
The command also supports a number of options:
- `--php`  sets the php version that the vagrant box will install
- `--forward-guest-port`  sets which port on the box to foward to the host
- `--forward-host-port`   sets which port on the host to view the guest port
- `--apache-web-dir`    installs apache which a specific document root
- `--vagrant-box`     to change teh default vagrant box

### Defaults:
PHP: 7.1
FORWARD_GUEST_PORT: 80
FORWARD_HOST_PORT: 8080
APACHE_WEB_DIR: /var/www/html
VAGRANT_BOX: ubuntu/xenial64

### Example Advanced Usage
This following command creates a directory called "my-project" and configures vagrant install the vagrant box "ubuntu/trusty64". It configures vagrant to forward the virtualbox's guest from 8080 to the host's port 3000. It installs php 5.6. It configures apache to serve the application from the document root "/var/www/html/public". Perhaps this configuration would be good for older laravel versions.

```
vagrant-create --php=5.6 \
    --forward-guest-port=8080 \
    --forward-host-port=3000 \
    --apache-web-dir=/var/www/html/public \
    --vagrant-box="ubuntu/trusty64" \
    my-project
```

# How it works
`vagrant-create [project_name]` will create a folder with what ever you put as the project name. It will then copy everything in `./proj` into that folder.

# Default Configuration
By default the dev environment created is an ubuntu/xenial64 vagrant box. `./proj/setup_assets/ubuntu_wp.sh` is the main provisioner. This will install php 7.1 and apache. It will also overwrite the default `/etc/apache2/sites-available/000-default.conf` with `./proj/setup_assets/apache_config.conf`. For any custom apache2 configuration, you can change the apache_config.conf file how ever you like before running `vagrant up` for the first time.

The `VagrantFile` in `./proj/` becomes the boxes VagrantFile. Feel free to change this as well before running `vagrant up` for the first time. In this file, there is a variable called `version` around line 23. This variable passes the version argument to the provisioner script, `ubuntu_wp.sh`, to tell the script which version of php to install. To tell vagrant to install the latest version, just change this variable to "latest". Right now, 5.6, 7.1 and latest are php versins supported.

# Feedback
Always welcome! Feel free to use this project. Just let me know how you like it. Diamond.joshh@gmail.com
