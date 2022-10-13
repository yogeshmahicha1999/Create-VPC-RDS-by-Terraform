##################################### access  ##################################

access_key = ""
secret_key = ""
region 	   = "ap-south-1"

############################### VPC and Subnet ###################################

vpc_cidr = "10.0.0.0/18"
vpc_name = "main-vpc"

public_subnet_name = "public"
public_subnet_cidr = "10.0.0.0/24"
public_subnet_availability_zone = "ap-south-1a" 

private1_subnet_name = "private1"
private1_subnet_cidr = "10.0.1.0/24"
private1_subnet_availability_zone = "ap-south-1a"

private2_subnet_name = "private2"
private2_subnet_cidr = "10.0.2.0/24"
private2_subnet_availability_zone = "ap-south-1b"

##################################### RDS ########################################

engine_name			=	 "mysql"
db_name				=	 "db"
user_name			=	 "admin"
pass 				=	"yogesh123"
multi_az_deployment		=	 false
public_access 			=	 false
skip_finalSnapshot 		=	 true
delete_automated_backup 	=	 true
instance_class 			=	 "db.t2.micro"
