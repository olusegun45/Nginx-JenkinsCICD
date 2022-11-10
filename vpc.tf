# Resource-1: create VPC
resource "aws_vpc" "Project-1-VPC" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "Project-1-VPC"
  }
}

# Resource-2: create Subnet
resource "aws_subnet" "Project-1-VPC-Pub-sbn" {
  vpc_id     = aws_vpc.Project-1-VPC.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-2b"
  map_public_ip_on_launch = true
    tags = {
    Name = "Project-1-VPC-Pub-sbn"
  }
}

# Resource-3: create internet gatewaay
resource "aws_internet_gateway" "Project-1-VPC-igw" {
  vpc_id = aws_vpc.Project-1-VPC.id
  
  tags = {
    Name = "Project-1-VPC-igw"
  }
}

# Resource-4: create public route table
resource "aws_route_table" "Project-1-VPC-Pub-RT" {
  vpc_id = aws_vpc.Project-1-VPC.id
}

# Resource-5: create route
resource "aws_route" "Project-1-VPC-Pub-Route" {
  route_table_id            = aws_route_table.Project-1-VPC-Pub-RT.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.Project-1-VPC-igw.id
  depends_on                = [aws_route_table.Project-1-VPC-Pub-RT]
  count                     = "1"
}

# Resource-6: Associate Public Route Table with Public subnet
resource "aws_route_table_association" "Project-1-VPC-Pub-RT-Asso" {
  subnet_id      = aws_subnet.Project-1-VPC-Pub-sbn.id
  route_table_id = aws_route_table.Project-1-VPC-Pub-RT.id
}
