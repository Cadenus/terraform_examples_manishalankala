


resource "aws_instance" "aws_ins" {

    ami = "${lookup(var.AMI, var.AWS_REGION)}"
    instance_type = "t2.micro"

    # VPC
    subnet_id = "${aws_subnet.subnet-public-3.id}"

    # Security Group
    vpc_security_group_ids = ["${aws_security_group.sshbyall.id}"]

}


# create Internet Gateway for vpc to connect with internet
resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.vpc.id}"

    tags = {
        Name = "arivu-igw"
    }
}

# public subnets route table
resource "aws_route_table" "public-rt" {
    vpc_id = "${aws_vpc.arivu-vpc.id}"
    route {
        cidr_block = "0.0.0.0/0" 
        gateway_id = "${aws_internet_gateway.igw.id}" 
    }

    tags = {
        Name = "arivu-public-rt"
    }
}

# route table association for the public subnets
resource "aws_route_table_association" "rta-public-subnet-3" {
    subnet_id = "${aws_subnet.subnet-public-3.id}"
    route_table_id = "${aws_route_table.public-rt.id}"
}

# security group
resource "aws_security_group" "sshbyall" {

    vpc_id = "${aws_vpc.vpc.id}"

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "sshbyall"
    }
}
