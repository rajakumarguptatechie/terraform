resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"
  

  tags = {
    Name = "tf-example"
    Team = "Test"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.cidr_address
  availability_zone = "us-east-2a"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "foo" {
  ami           = "ami-0c9c2203357e2568a" # us-east-2
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "standard"
  }
}
