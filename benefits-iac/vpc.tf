terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "trpdotdev-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "trpdotdev-vpc"
  }
}

resource "aws_subnet" "trpdotdev-public-subnet" {
  vpc_id     = aws_vpc.trpdotdev-vpc.id
  cidr_block = "10.0.0.0/24"
}

resource "aws_subnet" "trpdotdev-private-subnet" {
  vpc_id     = aws_vpc.trpdotdev-vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_internet_gateway" "trpdotdev-igw" {
  vpc_id = aws_vpc.trpdotdev-vpc.id
}

resource "aws_route_table" "trpdotdev-route-table" {
  vpc_id = aws_vpc.trpdotdev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.trpdotdev-igw.id
  }
}

resource "aws_route_table_association" "trpdotdev-public-subnet" {
  subnet_id      = aws_subnet.trpdotdev-public-subnet.id
  route_table_id = aws_route_table.trpdotdev-route-table.id
}
