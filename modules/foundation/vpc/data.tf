# Fetches all active Availability Zones in the current AWS region
data "aws_availability_zones" "available" {
  state = "available"
}
