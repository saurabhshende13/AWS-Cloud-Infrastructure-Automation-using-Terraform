resource "aws_eip" "nat_eip" {
  depends_on = [aws_internet_gateway.ig]
  tags = merge(
    var.tags,
    {
      Name = "${local.Name}-EIP-01"
    },
  )
}


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public.*.id, 0)
  depends_on    = [aws_internet_gateway.ig]

  tags = merge(
    var.tags,
    {
      Name = "${local.Name}-NAT-Gateway-01"
    },
  )
}
