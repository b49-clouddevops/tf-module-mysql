resource "aws_route53_record" "mysql-record" {
    # I'd need the zone details, which we have given in the vpc module, so we need to fetch the zone id from there. We are can read remote state from their outputs
  zone_id    = data.terraform_remote_state.vpc.outputs.HOSTEDZONE_PRIVATE_ID
  name       = "mysql-${var.ENV}.${data.terraform_remote_state.vpc.outputs.HOSTEDZONE_PRIVATE_ZONE}"
  type       = "CNAME"
  ttl        = 660
  records    = [aws_db_instance.mysql.address]
  depends_on = [aws_db_instance.mysql]
}