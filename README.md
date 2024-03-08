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
docker run -d —network some-network —name mysql-service DB_USER=ecomuser  —env DB_PASSWORD=ecompassword —env MARIADB_ROOT_PASSWORD=ecompassword -p 3306:3306 mariadb:latest
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
- Setup an [AWS EKS cluster](./terraform/) using Infrastructure As Code--Terraform