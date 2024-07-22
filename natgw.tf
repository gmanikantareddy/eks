/*
resource "aws_eip" "nat" {
    domain   = "vpc"

    tags = {
      Name = "${local.env}-elb"
    }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_zone1.id

  tags = {
    Name = "${local.env}-nat"
  }

  depends_on = [aws_internet_gateway.igw]
}
/*
/*resource "aws_instance" "nat" {
  ami           = "ami-0e1d06225679bc1c5"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_zone1.id
  associate_public_ip_address = true
  key_name      = "terraform-keypair"
  user_data = <<-EOF
              #!/bin/bash
              echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
              sysctl -p
              iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
              EOF

  tags = {
    Name = "NAT Instance"
  }
}

resource "aws_eip" "nat" {
  instance = aws_instance.nat.id
}


*/


data "aws_ami" "nat" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat*"]
  }
  filter {
    name   = "owner-id"
    values = ["137112412989"]  
  }
}


resource "aws_security_group" "nat_sg" {
  name        = "nat-instance-sg"
  description = "Allow HTTP, HTTPS, and SSH"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_80" {

    security_group_id = aws_security_group.nat_sg.id
    from_port   = 80
    to_port     = 80
    ip_protocol    = "tcp"
    cidr_ipv4 = "10.0.0.0/16"
    
}

resource "aws_vpc_security_group_ingress_rule" "allow_443" {

    security_group_id = aws_security_group.nat_sg.id
    from_port   = 443
    to_port     = 443
    ip_protocol    = "tcp"
    cidr_ipv4 = "10.0.0.0/16"
    
}

resource "aws_vpc_security_group_ingress_rule" "allow_22" {

    security_group_id = aws_security_group.nat_sg.id
    from_port   = 22
    to_port     = 22
    ip_protocol    = "tcp"
    cidr_ipv4 = "0.0.0.0/0"
    
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.nat_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}





resource "aws_instance" "nat" {
  ami           = data.aws_ami.nat.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_zone1.id 
  security_groups = [aws_security_group.nat_sg.id]
  

  tags = {
    Name = "NAT Instance"
  }

  source_dest_check = false

  
  user_data = <<-EOF
              #!/bin/bash
              # Additional configuration if needed
              EOF

  
  associate_public_ip_address = true

  key_name = "terraform-keypair"
  depends_on = [ aws_security_group.nat_sg ]
}

