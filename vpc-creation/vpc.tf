#Internet VPC
resource "aws_vpc" "hv" {
    cidr_block = "10.1.0.0/16"
	instance_tenancy = "default"
	enable_dns_support = "true"
	enable_dns_hostnames = "true"
	enable_classiclink = "false"
	tags {
	    Name = "hv"
	}
}

# Subnets
resource "aws_subnet" "hv-public-1" {
    vpc_id = "${aws_vpc.hv.id}"
	cidr_block = "10.1.1.0/24"
	map_public_ip_on_launch = "true"
	availability_zone = "us-east-2a"
	
	tags {
	    Name = "hv-public-1"
	}
}
resource "aws_subnet" "hv-public-2" {
    vpc_id = "${aws_vpc.hv.id}"
	cidr_block = "10.1.2.0/24"
	map_public_ip_on_launch = "true"
	availability_zone = "us-east-2b"
	
	tags {
	    Name = "hv-public-2"
	}
}
resource "aws_subnet" "hv-public-3" {
    vpc_id = "${aws_vpc.hv.id}"
	cidr_block = "10.1.3.0/24"
	map_public_ip_on_launch = "true"
	availability_zone = "us-east-2c"
	
	tags {
	    Name = "hv-public-3"
	}
}
resource "aws_subnet" "hv-private-1" {
    vpc_id = "${aws_vpc.hv.id}"
	cidr_block = "10.1.4.0/24"
	map_public_ip_on_launch = "false"
	availability_zone = "us-east-2a"
	
	tags {
	    Name = "hv-private-1"
	}
}
resource "aws_subnet" "hv-private-2" {
    vpc_id = "${aws_vpc.hv.id}"
	cidr_block = "10.1.5.0/24"
	map_public_ip_on_launch = "false"
	availability_zone = "us-east-2b"
	
	tags {
	    Name = "hv-private-2"
	}
}
resource "aws_subnet" "hv-private-3" {
    vpc_id = "${aws_vpc.hv.id}"
	cidr_block = "10.1.6.0/24"
	map_public_ip_on_launch = "false"
	availability_zone = "us-east-2c"
	
	tags {
	    Name = "hv-private-3"
	}
}

#Internet GW
resource "aws_internet_gateway" "hv-gw" {
    vpc_id = "${aws_vpc.hv.id}"
	
	tags {
	    Name = "hv"
	}
}

#Route tables
resource "aws_route_table" "hv-public" {
    vpc_id = "${aws_vpc.hv.id}"
	route {
	    cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.hv-gw.id}"
	}
	
	tags {
	    Name = "hv-public-1"
	}
}

#Route associations public
resource "aws_route_table_association" "hv-public-1-a" {
	subnet_id = "${aws_subnet.hv-public-1.id}"
	route_table_id = "${aws_route_table.hv-public.id}"
}
resource "aws_route_table_association" "hv-public-2-a" {
	subnet_id = "${aws_subnet.hv-public-2.id}"
	route_table_id = "${aws_route_table.hv-public.id}"
}
resource "aws_route_table_association" "hv-public-3-a" {
	subnet_id = "${aws_subnet.hv-public-3.id}"
	route_table_id = "${aws_route_table.hv-public.id}"
}

resource "aws_security_group" "aiops-test" {
  name        = "aiops test"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.hv.id}"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
tags {
    Name = "aiops test"
  }
}


resource "aws_vpc_peering_connection" "vpc-peer" {
  peer_owner_id = "560847904108"
  peer_vpc_id   = "vpc-7fd17e17"
  vpc_id        = "${aws_vpc.hv.id}"
  auto_accept   = true

  tags {
    Name = "VPC Peering between openshift and mi-aiops"
  }
}







