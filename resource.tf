############################################# Main VPC ############################

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

################################  Public-Subnet ###################################

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr
  availability_zone = var.public_subnet_availability_zone

  tags = {
    Name = var.public_subnet_name
  }
}	

###################################### Private-Subnet ###############################

#Private Subnet
# 1st subnet
resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private1_subnet_cidr
  availability_zone = var.private1_subnet_availability_zone

  tags = {
    Name = var.private1_subnet_name
  }
}
# 2nd subnet
resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private2_subnet_cidr
  availability_zone = var.private2_subnet_availability_zone

  tags = {
    Name = var.private2_subnet_name
  }
}

##############################################################################
############### internet-gateway ############ Nat-Gateway   #################



# MAin internet gateway for VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}

#Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}

#Main NAT Gateway for VPC
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "nat"
  }
}


############################ Route-Table-Public-subnet ##################################


# Route Table for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public"
  }
}

# Association between Public Subnet and Public Route Table

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}



############################ Route-Table-Private-subnet ##################################



# Route Table for Private Subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private"
  }
}

# Association between Private Subnet and Private Route Table
#1st subnet
resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}

# 2nd subnet 
resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}


################################ Subnet-Group  ########################################

#Subnet groups
resource "aws_db_subnet_group" "db_sub_group" {
  name       = "main"
  subnet_ids = [aws_subnet.private1.id, aws_subnet.private2.id]
  tags = {
    Name = "My_DB_subnet_group"
  }
}


################################## Security-Group #######################################

# Resource: aws_security_group
resource "aws_security_group" "VPC" {
  name        = "VPC"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Web Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

####################################     RDS      #######################################

resource "aws_db_instance" "db_instance" {
        engine                   = var.engine_name
        db_name                  = var.db_name
        username                 = var.user_name
        password                 = var.pass
        skip_final_snapshot      = var.skip_finalSnapshot
        db_subnet_group_name     = aws_db_subnet_group.db_sub_group.id
        delete_automated_backups = var.delete_automated_backup
        multi_az                 = var.multi_az_deployment
        publicly_accessible      = var.public_access
        vpc_security_group_ids   = [aws_security_group.VPC.id ]
        instance_class           = var.instance_class
        allocated_storage        = 20
}
