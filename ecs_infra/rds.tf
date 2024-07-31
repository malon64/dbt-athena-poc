resource "aws_db_subnet_group" "dagster" {
  name       = "dagster-dbt-app-db-subnet-group"
  subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
}

resource "aws_db_instance" "dagster_postgres" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "13"
  instance_class         = "db.t3.micro"
  db_name                = "dagsterdb"
  username               = "postgres_user"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.dagster.name
  publicly_accessible    = true
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Name = "dagsterdb"
  }
  depends_on = [aws_internet_gateway.igw]
}

