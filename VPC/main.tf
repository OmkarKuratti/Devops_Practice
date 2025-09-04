terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

provider "aws" {
  region = "ap_south_1"
}

resource "aws_vpc" "my_vpc" {
    tags = {
      name = "Project_vpc"
    }
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
}

#Subnets

resource "aws_subnet" "Subnet-1" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap_south_1a"
    map_public_ip_on_launch = true
    tags = {
      name = "Public_subnet-1"
    }
}

resource "aws_subnet" "Subnet-2" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "ap_south_1b"
    map_public_ip_on_launch = true
    tags = {
      name = "Public_subnet-2"
    }
}

resource "aws_subnet" "Subnet-3" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "ap_south_1a"
    map_public_ip_on_launch = false
    tags = {
      name = "Private_subnet-1"
    }
}

#Internet Gateway

resource "aws_internet_gateway" "My_internet_GW" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    name = "MyIGW"
  }
}

#Creating route table

resource "aws_route_table" "Public_route_table" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
      name = "custom_route_table"
    }
}

#Creating the route
resource "aws_route" "Public_route" {
    route_table_id = aws_route_table.Public_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.My_internet_GW.id
}

#creating the route association
resource "aws_route_table_association" "Public_subnet_association" {
    subnet_id = aws_subnet.Subnet-1.id
    route_table_id = aws_route_table.Public_route_table.id
  
}