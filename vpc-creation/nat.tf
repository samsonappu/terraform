#Nat_gw
resource "aws_eip" "nat" {
  vpc   = true
}
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.hv-public-1.id}"
  depends_on = ["aws_internet_gateway.hv-gw"]
}

#VPC setup for NAT
resource "aws_route_table" "hv-private-1" {
    vpc_id = "${aws_vpc.hv.id}"
	route {
		cidr_block = "0.0.0.0/0"
		nat_gateway_id = "${aws_nat_gateway.nat-gw.id}"
	}
	route {
                cidr_block = "10.0.0.0/16"
                vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc-peer.id}"
        }

	tags {
		Name = "hv-private-1"
	}
}


resource "aws_route" "mi-aiops" {
  route_table_id            = "rtb-d156ceb9"
  destination_cidr_block    = "10.1.0.0/16"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc-peer.id}"
}




#route associations private

resource "aws_route_table_association" "hv-private-1" {
    subnet_id = "${aws_subnet.hv-private-1.id}"
	route_table_id = "${aws_route_table.hv-private-1.id}"

}










