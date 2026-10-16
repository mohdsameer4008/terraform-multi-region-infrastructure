module "vpc_east" {
  source = "./modules/vpc"

  providers = {
    aws = aws.east
  }

  name                 = "project2-east"
  vpc_cidr             = "10.10.0.0/16"
  availability_zones   = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.10.1.0/24", "10.10.2.0/24"]
  private_subnet_cidrs = ["10.10.11.0/24", "10.10.12.0/24"]
}

module "vpc_west" {
  source = "./modules/vpc"

  providers = {
    aws = aws.west
  }

  name                 = "project2-west"
  vpc_cidr             = "10.20.0.0/16"
  availability_zones   = ["us-west-2a", "us-west-2b"]
  public_subnet_cidrs  = ["10.20.1.0/24", "10.20.2.0/24"]
  private_subnet_cidrs = ["10.20.11.0/24", "10.20.12.0/24"]
}
