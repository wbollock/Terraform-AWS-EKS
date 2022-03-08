module "database" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  identifier = "wordpress-prod-db"

  engine         = "mysql"
  engine_version = "5.7"
  instance_class = "db.t2.small"

  # Storage will autoscale
  allocated_storage     = 5
  max_allocated_storage = 100

  name     = "wordpress"
  username = "root"
  password = var.db_password
  port     = "3306"

  iam_database_authentication_enabled = true

  vpc_security_group_ids = ["${module.db_vpc.default_security_group_id}", "${aws_security_group.allow_apps.id}"]

  # Not worth cost for Multi-AZ as a demo
  multi_az = "false"

  # Backups and general managed chores
  maintenance_window      = "Wed:00:00-Wed:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = "35"

  # enable Enhanced Monitoring 
  monitoring_role_name   = "RDSMonitoringRole"
  create_monitoring_role = true

  tags = {
    Environment = "prod"
  }

  # DB subnet group
  subnet_ids = module.db_vpc.private_subnets

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  create_db_option_group = "false"
  major_engine_version   = "5.7"

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8"
    },
    {
      name  = "character_set_server"
      value = "utf8"
    }
  ]

}

resource "aws_security_group" "allow_apps" {
  name        = "allow_apps"
  description = "Allow apps inbound traffic and database outbound traffic"
  vpc_id      = module.db_vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.app_cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
