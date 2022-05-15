# Parameter & Option group
resource "aws_db_parameter_group" "your_app_name" {
  name   = "${var.db_param_group_name}"
  family = "mysql5.7"

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}
resource "aws_db_option_group" "your_app_name" {
  name   = "${var.db_option_group_name}"
  engine_name          = "mysql"
  major_engine_version = "5.7"

  option {
    option_name = "MARIADB_AUDIT_PLUGIN"
  }
}

# Subnet group
resource "aws_db_subnet_group" "your_app_name" {
  name       = "example"
  subnet_ids = [aws_subnet.private_0.id, aws_subnet.private_1.id]
}

# Security group
module "mysql_sg" {
  source      = "./security_group"
  name        = "mysql-sg"
  vpc_id      = aws_vpc.your_app_name.id
  port        = 3306
  cidr_blocks = [aws_vpc.your_app_name.cidr_block]
}

# DB
resource "aws_db_instance" "your_app_name" {
  identifier                 = "${var.db_identifier}"
  engine                     = "mysql"
  engine_version             = "5.7.25"
  instance_class             = "${var.db_instance_class}"
  allocated_storage          = 20
  max_allocated_storage      = 100
  storage_type               = "gp2"
  storage_encrypted          = true
  kms_key_id                 = aws_kms_key.your_app_name.arn
  username                   = "${var.db_user_name}"
  password                   = "${var.db_password}"
  multi_az                   = true
  publicly_accessible        = false
  backup_window              = "09:10-09:40"
  backup_retention_period    = 30
  maintenance_window         = "mon:10:10-mon:10:40"
  auto_minor_version_upgrade = false
  deletion_protection        = "${var.db_delete_protection}"
  skip_final_snapshot        = false
  port                       = 3306
  apply_immediately          = false
  vpc_security_group_ids     = [module.mysql_sg.security_group_id]
  parameter_group_name       = aws_db_parameter_group.your_app_name.name
  option_group_name          = aws_db_option_group.your_app_name.name
  db_subnet_group_name       = aws_db_subnet_group.your_app_name.name

  lifecycle {
    ignore_changes = [password]
  }
}