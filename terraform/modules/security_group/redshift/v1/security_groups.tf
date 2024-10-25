resource "aws_security_group" "sg" {
  name = "redshift-sg1"
  vpc_id = var.vpc.id
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 5439
    to_port = 5439
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}
