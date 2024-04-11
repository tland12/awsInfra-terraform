variable "region" {
  type = string
  default = "us-west-2"
  description = "aws region"
}

variable "az1" {
  type = string
  default = "us-west-2a"
  description = "aws availability zone"
}
variable "az2" {
  type = string
  default = "us-west-2b"
  description = "aws availability zone"
}
variable "az3" {
  type = string
  default = "us-west-2c"
  description = "aws availability zone"
}

variable "amiAL2023" {
  type = string
  default = "ami-0395649fbe870727e"
  description = "us-west-2 AL2023 ami"
}
