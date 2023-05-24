# flipthescript

Set my ip with
````
export TF_VAR_my_ip="<LOCAL_IP>"
````

1. Import SSH keys to the AWS account
2. Store the db secret in the AWS Secret Manager
3. Access the bastion with private key
````
ssh -i ~/.ssh/talent-academy-myec2 ubuntu@<PUBLIC_IP_BASTION>
````

4. Connect to the db from the bastion
````
mysql -h 127.0.0.1 -h <RDS_ENDPOINT> -u root -p
````

5.

````



````



Error

   telnet <***.eu-central-1.rds.amazonaws.com> 3306
Trying 10.0.2.54...
telnet: connect to address 10.0.2.54: Operation timed out
telnet: Unable to connect to remote host

docker run --name flipthescript-db -p 3306:3306 -v ~/src/talent-academy/mysql_databases/flipthescript_db:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=<PASSWORD> -d mysql:latest