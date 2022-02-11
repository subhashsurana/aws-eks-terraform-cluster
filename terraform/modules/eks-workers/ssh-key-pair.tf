//Creating Key
resource "tls_private_key" "tls_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

//Generating Key-Value Pair
resource "aws_key_pair" "generated_key" {
  key_name   = "eks-key"
  public_key = tls_private_key.tls_key.public_key_openssh

  depends_on = [
    tls_private_key.tls_key
  ]

}

//Saving Private Key PEM File
resource "local_file" "key-file" {
  content  = tls_private_key.tls_key.private_key_pem
  filename = "devsbh/home/.ssh/${var.generated_key_name}.pem"

  depends_on = [
    tls_private_key.tls_key
  ]
}