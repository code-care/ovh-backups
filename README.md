# Intro
Bash script which helps to make backup of your files and MySQL database

1) It organize backups by day of the month and hour. We do backups every 3 hours and keep them for a month.
Every new backup on the 1st day of the month overwrite backup from the 1st day of the last month. 

If you want to change it you need to manipuate `ZIP_PACKAGE` and `MYSQL_PACKAGE` variables

# Set up
1) Go to your public cloud panel in OVH
2) Choose your project and go to `Users` menu in `Project management` section
https://www.ovh.com/manager/public-cloud/index.html#/pci/projects/{YourProjectId}/users
3) Add new user or use existing one and download OpenStack RC File
4) Edit `openrc.sh` file and find this section

```
# With Keystone you pass the keystone password.
echo "Please enter your OpenStack Password: "
read -sr OS_PASSWORD_INPUT
export OS_PASSWORD=$OS_PASSWORD_INPUT
```
Because we don't want to pass password everytime when we do backup we'll write it down into the script.
Change this section to something like this
```
# With Keystone you pass the keystone password.
export OS_PASSWORD="HERE PASS YOUR USER PASSWORD"
```

5) And you're ready to go

# Run backup.sh
1) Create for example `/backup` directory on the server.
2) Put through scp `openrc.sh` and `backup.sh` files to this directory
3) You can run your first backup by setting correct ENV variables

```
DATABASE_HOSTNAME=localhost DATABASE_USERNAME= DATABASE_PASSWORD= DATABASE_NAME= PROJECT_NAME= PROJECT_PATH=/var/www/html/codecare.pl CONTAINER_NAME="CodeCare.pl" sh backup.sh 
```

# Environmental variables
1) `DATABASE_HOSTAME` - This is your MySQL database hostname
2) `DATABASE_USERNAME` - This is your MySQL database username. It's not recommended to use `root` user here.
3) `DATABASE_NAME` - Name of the database which you want to dump
4) `PROJECT_NAME` - Give some name to the project so you can recognize files later :) 
5) `PROJECT_PATH` - Here pass the path to the files which you want to zip and dump.
6) `CONTAINER_NAME` - Name of your container in Cloud Archive or Object Storage

# Cron setup
Of course you want to make backups regularly. You can setup CRON job with above params. That's why we changed password section in openrc.sh

Example crontab
```
* */3 * * * DATABASE_HOSTNAME=localhost DATABASE_USERNAME= DATABASE_PASSWORD= DATABASE_NAME= PROJECT_NAME= PROJECT_PATH=/var/www/html/codecare.pl CONTAINER_NAME="CodeCare.pl" sh backup.sh 
```

Feel free to edit this file as you want, if you have version for PostgreSQL or any other type of database don't hesitate to create Pull Request
and add something in here. I promise I'll review that.
