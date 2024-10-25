resource "aws_glue_catalog_table" "t" {
  name          = var.db_name
  database_name = aws_glue_catalog_database.db.name
}

resource "aws_glue_catalog_database" "db" {
  name = var.db_name
}