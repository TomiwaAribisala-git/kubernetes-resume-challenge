# This repository is a solution of the [Kubernetes Resume Challenge](https://cloudresumechallenge.dev/docs/extensions/kubernetes-challenge/).

# This project highlights proficiency in Kubernetes and containerization, demonstrating the ability to deploy, scale, and manage web applications efficiently in a K8s environment, underscoring cloud-native deployment skills.

## Prerequisites 
- [x] Docker & K8s CLI installed
- [x] KodeKloud K8s Crash Course Completed 
- [x] AWS Account Setup
- [x] Github Account Setup
- [x] Ecommerce Application & DB Script Overview

## Database Containerization & Web Application Containerization(Local Testing using Docker Desktop)
- For testing purposes locally, i pulled/ran the MariaDB image as the database container in a docker network
```sh
docker run -d —network some-network —name mysqlservice —env DB_NAME=ecomdb DB_USER=ecomuser  —env DB_PASSWORD=ecompassword —env MARIADB_ROOT_PASSWORD=ecompassword -p 3306:3306 mariadb:latest
```
- I accessed the database container to run SQL statements--which creates a database in the database server
```sh
docker run -it --network some-network --rm mariadb mariadb -h mysql-service -u root -p
```
```sql
CREATE DATABASE ecomdb;
```
```sql
CREATE USER 'ecomuser'@'localhost' IDENTIFIED BY 'ecompassword';
```
```sql
GRANT ALL PRIVILEGES ON ecomdb.* TO 'ecomuser'@'localhost';
```
```sql
FLUSH PRIVILEGES;
```
```sql
exit
```
- Loaded data into the new database and queried the data
```sql
USE ecomdb;
```
```sql
CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Price varchar(255) default NULL, ImageUrl varchar(255) default NULL,PRIMARY KEY (id)) AUTO_INCREMENT=1;
```
```sql
INSERT INTO products (Name,Price,ImageUrl) VALUES ("Laptop","100","c-1.png"),("Drone","200","c-2.png"),("VR","300","c-3.png"),("Tablet","50","c-5.png"),("Watch","90","c-6.png"),("Phone Covers","20","c-7.png"),("Phone","80","c-8.png"),("Laptop","150","c-4.png");
```
```sql
select * from ecomdb.products; 
```
- I wrote a [Dockerfile](./Dockerfile) at the root of the Web Application
- I built a Docker image for the application and started the image in the same network as the database container
```sh
docker build -t ecom-web:v1 .
```
```sh
 docker run -d —network some-network —name ecom-web -p 8080:80 ecom-web:v1
```

## Implement CI(Continuous Integration)
- Created a [`.github/workflows/deploy.yml`](./.github/workflows/deploy.yml) file to build the Docker image and push it to Docker Hub

## Setup Kubernetes Cluster on AWS

































# Running The Application

This is a sample e-commerce application built for learning purposes.

Here's how to deploy it on CentOS systems:

## Deploy Pre-Requisites

1. Install FirewallD

```
sudo yum install -y firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo systemctl status firewalld
```

## Deploy and Configure Database

1. Install MariaDB

```
sudo yum install -y mariadb-server
sudo vi /etc/my.cnf
sudo systemctl start mariadb
sudo systemctl enable mariadb
```

2. Configure firewall for Database

```
sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp
sudo firewall-cmd --reload
```

3. Configure Database

```
$ mysql
MariaDB > CREATE DATABASE ecomdb;
MariaDB > CREATE USER 'ecomuser'@'localhost' IDENTIFIED BY 'ecompassword';
MariaDB > GRANT ALL PRIVILEGES ON *.* TO 'ecomuser'@'localhost';
MariaDB > FLUSH PRIVILEGES;
```

> ON a multi-node setup remember to provide the IP address of the web server here: `'ecomuser'@'web-server-ip'`

4. Load Product Inventory Information to database

Create the db-load-script.sql

```
cat > db-load-script.sql <<-EOF
USE ecomdb;
CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Price varchar(255) default NULL, ImageUrl varchar(255) default NULL,PRIMARY KEY (id)) AUTO_INCREMENT=1;

INSERT INTO products (Name,Price,ImageUrl) VALUES ("Laptop","100","c-1.png"),("Drone","200","c-2.png"),("VR","300","c-3.png"),("Tablet","50","c-5.png"),("Watch","90","c-6.png"),("Phone Covers","20","c-7.png"),("Phone","80","c-8.png"),("Laptop","150","c-4.png");

EOF
```

Run sql script

```
sudo mysql < db-load-script.sql
```


## Deploy and Configure Web

1. Install required packages

```
sudo yum install -y httpd php php-mysqlnd
sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
sudo firewall-cmd --reload
```

2. Configure httpd

Change `DirectoryIndex index.html` to `DirectoryIndex index.php` to make the php page the default page

```
sudo sed -i 's/index.html/index.php/g' /etc/httpd/conf/httpd.conf
```

3. Start httpd

```
sudo systemctl start httpd
sudo systemctl enable httpd
```

4. Download code

```
sudo yum install -y git
sudo git clone https://github.com/kodekloudhub/learning-app-ecommerce.git /var/www/html/
```

5. Update index.php

Update [index.php](https://github.com/kodekloudhub/learning-app-ecommerce/blob/13b6e9ddc867eff30368c7e4f013164a85e2dccb/index.php#L107) file to connect to the right database server. In this case `localhost` since the database is on the same server.

```
sudo sed -i 's/172.20.1.101/localhost/g' /var/www/html/index.php

              <?php
                        $link = mysqli_connect('172.20.1.101', 'ecomuser', 'ecompassword', 'ecomdb');
                        if ($link) {
                        $res = mysqli_query($link, "select * from products;");
                        while ($row = mysqli_fetch_assoc($res)) { ?>
```

> ON a multi-node setup remember to provide the IP address of the database server here.
```
sudo sed -i 's/172.20.1.101/localhost/g' /var/www/html/index.php
```

6. Test

```
curl http://localhost
```
