output "ALB-sg" {
  value = aws_security_group.my-SG["ext-alb-sg"].id
}


output "IALB-sg" {
  value = aws_security_group.my-SG["int-alb-sg"].id
}


output "bastion-sg" {
  value = aws_security_group.my-SG["bastion-sg"].id
}


output "nginx-sg" {
  value = aws_security_group.my-SG["nginx-sg"].id
}


output "web-sg" {
  value = aws_security_group.my-SG["webserver-sg"].id
}


output "datalayer-sg" {
  value = aws_security_group.my-SG["datalayer-sg"].id
}

output "compute-sg" {
  value = aws_security_group.my-SG["compute-sg"].id
}
