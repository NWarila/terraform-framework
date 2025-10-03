#% =========================================================================================== %#
#% = File: 12-variables-aws.tf                                   | Category: variables (10-19) %#
#% ------------------------------------------------------------------------------------------- %#
#% =========================================================================================== %#

# Define Provider Configuration Options.
variable "aws_config" {
  description = "Define all of the required environmental variables specific to the AWS provider."
  type        = object({
    regions       = list(string)
  })

  default = {
    regions = ["us_iso_east_1", "us_iso_west_1"]
  }
}

