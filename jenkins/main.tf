locals {
  name = "sockshop"
}

#  Creating All Network Resources
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${local.name}-vpc"
  }
}

# Public subnet 1 resource
resource "aws_subnet" "pubsub1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "${local.name}-pubsub1"
  }
}

# Public subnet 2 resource
resource "aws_subnet" "pubsub2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1d"
  tags = {
    Name = "${local.name}-pubsub2"
  }
}

# Public subnet 3 resource
resource "aws_subnet" "pubsub3" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1e"
  tags = {
    Name = "${local.name}-pubsub3"
  }
}

# Private subnet 1 resource
resource "aws_subnet" "prvtsub1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "${local.name}-prvtsub1"
  }
}

# Private subnet 2 resource
resource "aws_subnet" "prvtsub2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1d"

  tags = {
    Name = "${local.name}-prvtsub2"
  }
}

# Private subnet 3 resource
resource "aws_subnet" "prvtsub3" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-east-1e"

  tags = {
    Name = "${local.name}_prvtsub3"
  }
}

# Creating Internet Gateway resource
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${local.name}_IGW"
  }
}

# # Creating NAT Gateway association with Public subnet 1 resource
# resource "aws_nat_gateway" "NAT" {
#   allocation_id = "aws_eip.nat_eip"
#   subnet_id     = "aws_subnet.pubsub1.id"
#   tags = {
#     "Name" = "${local.name}_NAT"
#   }
# }

# # Creating Elastic IP resource for NAT Gateway
# resource "aws_eip" "nat_eip" {
#   domain     = "vpc"
#   depends_on = [aws_internet_gateway.IGW]
#   tags = {
#     "Name" = "${local.name}_eip"
#   }
# }


# Creating Public Route Table resource
resource "aws_route_table" "PubRT" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    "Name" = "${local.name}_PubRT"
  }
}

# # Creating Private Route Table resource
# resource "aws_route_table" "PrvtRT" {
#   vpc_id = aws_vpc.vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.NAT.id
#   }
#   tags = {
#     "Name" = "${local.name}_PrvtRT"
#   }
# }

# Creating Public Subnet 1 Route Table association resource
resource "aws_route_table_association" "pubsub1_RT_ass" {
  route_table_id = aws_route_table.PubRT.id
  subnet_id      = aws_subnet.pubsub1.id
}

# Creating Public Subnet 2 Route Table association resource
resource "aws_route_table_association" "pubsub2_RT_ass" {
  route_table_id = aws_route_table.PubRT.id
  subnet_id      = aws_subnet.pubsub2.id
}

# Creating Public Subnet 2 Route Table association resource
resource "aws_route_table_association" "pubsub3_RT_ass" {
  route_table_id = aws_route_table.PubRT.id
  subnet_id      = aws_subnet.pubsub3.id
}

# # Creating Private Subnet 1 Route Table association resource
# resource "aws_route_table_association" "prvtsub1_RT_ass" {
#   route_table_id = aws_route_table.PrvtRT.id
#   subnet_id      = aws_subnet.prvtsub1.id
# }

# # Creating Private Subnet 2 Route Table association resource
# resource "aws_route_table_association" "prvtsub2_ass" {
#   route_table_id = aws_route_table.PrvtRT.id
#   subnet_id      = aws_subnet.pubsub2.id
# }

# # Creating Private Subnet 1 Route Table association resource
# resource "aws_route_table_association" "prvtsub3_RT_ass" {
#   route_table_id = aws_route_table.PrvtRT.id
#   subnet_id      = aws_subnet.prvtsub3.id
# }

# Jenkins Security Group Resource
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "http proxy port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "http port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "http proxy port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "${local.name}jenkins_sg"
  }
}

# TLS RSA Public & Private key Resource
resource "tls_private_key" "tlskey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Local Private key File of the TLS key Resource
resource "local_file" "sshkey" {
  content         = tls_private_key.tlskey.private_key_pem
  file_permission = "600"
  filename        = "jenkins_keypair.pem"
}

# AWS Keypair Resource
resource "aws_key_pair" "project_key" {
  key_name   = "jenkins_keypair"
  public_key = tls_private_key.tlskey.public_key_openssh
}

# Creating EC2 Instance for jenkins Server

resource "aws_instance" "jenkins_server" {
  ami                         = "ami-023c11a32b0207432" # redhat ami us east 1
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  key_name                    = aws_key_pair.project_key.id
  subnet_id                   = aws_subnet.pubsub1.id
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.id
  associate_public_ip_address = true
  user_data                   = local.jenkins_user_data
  tags = {
    "Name" = "${local.name}_jenkins"
  }
}

# Creating IAM Policy
resource "aws_iam_role_policy_attachment" "jenkins_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.ec2_role.name
}

# # Creating IAM Role
# resource "aws_iam_role" "ec2_role" {
#   name               = "ec2_rule"
#   assume_role_policy = file(path.root/ec2_assume.json)
# }

# Creating IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "ec2_role"
  }
}