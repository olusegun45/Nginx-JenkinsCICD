# Resource-7: Creat Security Group for Web Server
resource "aws_security_group" "Jenkins-server-SG" {
  name        = "Jenkins-server-SG"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_vpc.Project-1-VPC.id

  ingress    {
      description      = "TLS from Internet"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
          }
          
  ingress    {
      description      = "SSH Connection"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

  ingress    {
      description      = "All traffic"
      from_port         = 0
      to_port           = 65535
      protocol          = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

  egress     {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

  tags = {
    Name = "Jenkins-server-SG"
  }
}

# Resource-8: Creat ubuntu machine EC2 for Jenkins Server
resource "aws_instance" "Jenkins-server" {
  ami           = "ami-02f3416038bdb17fb"
  instance_type = "t2.micro"
  key_name      = "XXXXXXXXXXXXX"
  subnet_id     = aws_subnet.Project-1-VPC-Pub-sbn.id
  vpc_security_group_ids = [aws_security_group.Jenkins-server-SG.id]
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get install nginx -y
              echo "Welcome to Patara Web Application Server" > /var/www/html/index.html
              sudo apt-get update -y
              sudo service httpd start
              
              sudo apt-get install openjdk-11-jre -y

              sudo curl -fsSL https://pkg.jenkins.io/debian/jenkins.io.key | sudo tee \
                /usr/share/keyrings/jenkins-keyring.asc > /dev/null
                
              echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
                https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
                /etc/apt/sources.list.d/jenkins.list > /dev/null
              
              sudo apt-get update -y
              
              sudo apt-get install jenkins -y

              sudo servive jenkins start
              
              EOF

  tags = {
    Name = "Jenkins-server"
  }
}

# Resource-9: Creat Security Group for Build Server
resource "aws_security_group" "Build-Server-SG" {
  name        = "Build-Server-SG"
  description = "Allow SSH only from jenkins server"
  vpc_id      = aws_vpc.Project-1-VPC.id

  
  ingress    {
      description      = "SSH Connection"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

  egress     {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

  tags = {
    Name = "Build-Server-SG"
  }
}
# Resource-10: Creat linux Server for Build-Server
resource "aws_instance" "Build-Server" {
  ami           = "ami-074cce78125f09d61"
  instance_type = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.Build-Server-profile.name}"
  key_name      = "XXXXXXXXXXXXX"
  subnet_id     = aws_subnet.Project-1-VPC-Pub-sbn.id
  vpc_security_group_ids = [aws_security_group.Build-Server-SG.id]
  user_data = <<-EOF
              #!/bin/bash
	
	            # install dependencies
	            yum -y group install “Development Tools”
	            yum -y install \
		                bzip2-devel.x86_64 \
		                java-11-amazon-corretto-headless \
		                libffi-devel \
		                ncurses-devel \
		                openssl-devel \
		                python3 \
		                readline-devel.x86_64 \
		                sqlite-devel.x86_64 \
		                zlib-devel
	
	            # install the elastic beamstalk CLI
	            curl -0 https://bootstrap.pypa.io/get-pip.py
	            /usr/bin/python3 get-pip.py
	            /usr/local/bin/pip3 install awsebcli

              EOF

  tags = {
    Name = "Build-Server"
  }
}


/*
# Resource-9: Creat Ubuntu Server for EKS
resource "aws_instance" "EKS-server" {
  ami           = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"
  key_name      = "XXXXXXXXXXXXX"
  subnet_id     = aws_subnet.Project-1-VPC-Pub-sbn.id
  vpc_security_group_ids = [aws_security_group.project-SG.id]

  tags = {
    Name = "EKS-server"
  }
}
*/
