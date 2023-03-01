resource "aws_vpc" "prime" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "prime"
  }
}

#to create igw
#https://registry.terraform.io/providers/aaronfeng/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "prime-igw" {
  vpc_id = aws_vpc.prime.id

  tags = {
    Name = "prime-igw"
  }
}

#to create a public subnet
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet.html

resource "aws_subnet" "prime-pub1" {
  vpc_id            = aws_vpc.prime.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "prime-pub1"
  }
}
#creating pub subnet 2

resource "aws_subnet" "prime-pub2" {
  vpc_id            = aws_vpc.prime.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "prime-pub2"
  }
}
#creating route tables

resource "aws_route_table" "prime-pub-route_table" {
  vpc_id = aws_vpc.prime.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prime-igw.id
  }
  tags = {
    name = "prime-pub-route_table"
  }
}

#ass0ciating subnet 1
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association

resource "aws_route_table_association" "prime-pub1" {
  subnet_id      = aws_subnet.prime-pub1.id
  route_table_id = aws_route_table.prime-pub-route_table.id
}
#ass0ciating subnet 2
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association

resource "aws_route_table_association" "prime-pub2" {
  subnet_id      = aws_subnet.prime-pub2.id
  route_table_id = aws_route_table.prime-pub-route_table.id
}

# creating private sub-1
resource "aws_subnet" "prime-priv1" {
  vpc_id            = aws_vpc.prime.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "prime-priv1"
  }
}
# creating private sub-2
resource "aws_subnet" "prime-priv2" {
  vpc_id            = aws_vpc.prime.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1d"
  tags = {
    Name = "prime-priv2"
  }
}
resource "aws_route_table" "prime-priv-rt" {
  vpc_id = aws_vpc.prime.id

  route = []

  tags = {
    Name = "prime-private-rt"
  }
}
#ass0ciating subnet 
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association

resource "aws_route_table_association" "prime-priv1-rt" {
  subnet_id      = aws_subnet.prime-priv1.id
  route_table_id = aws_route_table.prime-priv-rt.id
}
#ass0ciating subnet 
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association

resource "aws_route_table_association" "prime-priv2-rt" {
  subnet_id      = aws_subnet.prime-priv2.id
  route_table_id = aws_route_table.prime-priv-rt.id
}