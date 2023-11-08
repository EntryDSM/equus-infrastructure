locals {
  db_type              = "db.t3.micro"
  db_engine            = "mysql"
  db_storage_size      = 20
  db_username          = "admin"
  db_subnet_group_name = aws_db_subnet_group.rds.name
  db_public_accessible = true
}

resource "aws_db_subnet_group" "rds" {
  name = "rds-subnet-group-${module.vpc.vpc_id}"
  subnet_ids = module.vpc.public_subnet_ids
}

resource "aws_security_group" "db_sg" {
  name        = "db-security-group"
  description = "Security group for rds on port 3306"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "equus-db" {
  identifier             = "${local.name_prefix}-db"
  allocated_storage      = local.db_storage_size
  engine                 = local.db_engine
  instance_class         = local.db_type
  availability_zone      = "${data.aws_region.current.name}c"
  username               = local.db_username
  password               = var.rds_master_password
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = local.db_subnet_group_name
  publicly_accessible    = local.db_public_accessible
}
