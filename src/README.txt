# GET STARTED
simply run `vagrant up`

# FILES & DiRECTORIES
- `./setup_assets` : Where our provisioner script lives. `provisioner.sh`
- `./downloads` : a place to hold random files and downloads associated with creating your project. Put what ever you want here.
- `./apache_logs` : Apache is configured by default to place the apache logs here. This way you don't have to run `vagrant ssh` and then cd over to `/var/logs/apache2/` to read your apache logs
- `Vagrantfile` : your vagrant boxes vagrant configuration
