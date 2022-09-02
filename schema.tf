resource "null_resource" "schema" {
  provisioner "local-exec" {
    # Injecting the schema from the ws 
    command = <<EOF 

EOF

  }
}