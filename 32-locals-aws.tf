#% =========================================================================================== %#
#% = File: 32-locals-aws.tf                                         | Category: locals (30-39) %#
#% ------------------------------------------------------------------------------------------- %#
#% The locals files is where the real heavy lifting for building the working objects used by   %#
#%    resources blocks is done. within "locals", all objects defined elsewhere (i.e. data,     %#
#%    variable, etc.) processed here to prepare the object(s) for action. This file is         %#
#%    intentionally designed to be the "brain" of the plan.                                    %#
#% =========================================================================================== %#

# Statically Configured LOCALS
locals {
  amazon_machine_images = {
    "red_hat_enterprise_linux_8" = {
      us_iso_west_1 = try(data.aws_ami.us_iso_west_1_red_hat_enterprise_linux_8[0], null)
      us_iso_east_1 = try(data.aws_ami.us_iso_east_1_red_hat_enterprise_linux_8[0], null)
    }
    "windows_server_2022_base" = {
      us_iso_west_1 = try(data.aws_ami.us_iso_west_1_windows_server_2022_base[0], null)
      us_iso_east_1 = try(data.aws_ami.us_iso_east_1_windows_server_2022_base[0], null)
    }
  }
}


# Dynamically Configured LOCALS
locals {

  elastic_compute_cloud = {
    for region in var.aws_config.regions: region => {
      for system in var.all_systems: system.hostname => {

        #region           = < This is set statically >
        ami               = system.ami
        availability_zone = system.availability_zone
        key_name          = system.key_name
        hostname          = system.hostname
        instance_type     = system.instance_type
        refresh           = system.refresh
        set_state         = system.set_state

        root_block_device = {
          volume_size           = system.root_block_device.volume_size
          volume_type           = system.root_block_device.volume_type
          encrypted             = true
          kms_key_id            = system.aws_kms_alias
          delete_on_termination = system.root_block_device.delete_on_termination

          tags = merge(
            system.root_block_device.tags,
            {
              index       = 0
              Name        = system.hostname
              Environment = var.environment
            }
          )
        }

        tags = merge(
          # Overwriteable Default Tags
          {
            Backup       = try(system.tags["Backup"],       "True")
          },
          system.tags,
          # Non-Overwritable Default Tags
          {
            Name         = "${system.hostname}"
            Environment  = "${var.environment}"
            Terraform    = "True"
            OS           = local.amazon_machine_images[system.ami][region].platform_details
          }
        )
      }
      # Normalize 'region' variable input to align with Terraform best practices.
      if replace(system.region,"-","_") == region
    }
  }

  elastic_network_interfaces = {
    for region in var.aws_config.regions: region => merge([
      for system in var.all_systems : {
        for index in range(length(system.network_interfaces)) :
          "${system.hostname}-eni-${index}" => {

          # AWS Network Interface Properties
          description     = system.network_interfaces[index].description
          interface_type  = system.network_interfaces[index].interface_type
          private_ips     = [system.network_interfaces[index].private_ip]
          security_groups = system.network_interfaces[index].security_groups
          subnet_id       = system.subnet_id

          # ?Note: Merges all of the defined user tags (if any) with the 'default' automatically
          # ?      calculated tags. The default tags cannot be overwritten, if the user provides
          # ?      tags with the same name, the default tags will take precedence.
          tags            = merge(
            system.network_interfaces[index].tags,
            {
              Index       = index
              Name        = system.hostname
              Environment = var.environment
            }
          )
        }
      }
      # Normalize 'region' variable input to align with Terraform best practices.
      if replace(system.region,"-","_") == region
    ]...)
  }

  ebs_block_devices = {
    for region in var.aws_config.regions: region => merge([
      for system in var.all_systems : {
        for index in range(length(system.ebs_block_devices)) :
          "${system.hostname}-ebs-${index}" => {

          # AWS Network Interface Properties
          availability_zone     = system.availability_zone
          delete_on_termination = system.ebs_block_devices[index].delete_on_termination
          encrypted             = true
          iops                  = system.ebs_block_devices[index].iops
          refresh               = system.refresh
          snapshot_id           = system.ebs_block_devices[index].snapshot_id
          throughput            = system.ebs_block_devices[index].throughput
          volume_size           = system.ebs_block_devices[index].volume_size
          volume_type           = system.ebs_block_devices[index].volume_type

          # ?Note: This is property relies on a data lookup, which is region specific, so its
          # ?  final value is actually calculated in the 'aws_ebs_volume' resource.
          kms_key_id = system.aws_kms_alias

          # ?Note: Merges all of the defined user tags (if any) with the 'default' automatically
          # ?      calculated tags. The default tags cannot be overwritten, if the user provides
          # ?      tags with the same name, the default tags will take precedence.
          tags = merge(
            try(system.ebs_block_devices[index].tags, {}),
            {
              Name                = system.hostname
              Index               = index
              Environment         = var.environment
              # ?Note: Dynamically assign a predictable device name by using the index to increment
              # ?      a [char] lookup. Unicode character set is used in the conversation, so
              # ?      [INT]100 converted to Unicode [CHAR] is'd', then each index increment after
              # ?      that will itterate through next characters (I.E. e, f, g, h, etc.)
              DeviceName = can(regex(
                "[Ww]indows",
                local.amazon_machine_images[system.ami][region].platform
              )) ? "xvd${jsondecode(format("\"\\u%04x\"", 100 + index))}" : (
                "/dev/sd${jsondecode(format("\"\\u%04x\"", 100 + index))}"
              )
            }
          )
        }
      }
      # Normalize 'region' variable input to align with Terraform best practices.
      if replace(system.region,"-","_") == region && system.ebs_block_devices != null
    ]...)
  }


  relational_database_service = {
    for region in var.aws_config.regions: region => {
      for database in var.all_databases: database.db_name => {

        allocated_storage           = database.allocated_storage
        availability_zone           = database.availability_zone
        backup_retention_period     = database.backup_retention_period
        backup_window               = database.backup_window
        blue_green_update           = database.blue_green_update
        ca_cert_identifier          = database.ca_cert_identifier
        db_name                     = database.db_name
        db_subnet_group_name        = database.db_subnet_group_name
        dedicated_log_volume        = database.dedicated_log_volume
        delete_automated_backups    = database.delete_automated_backups
        deletion_protection         = database.deletion_protection
        engine                      = database.engine
        engine_version              = database.engine_version
        final_snapshot_identifier   = try(database.identifier, "${database.db_name}-FINAL")
        identifier                  = try(database.identifier, lower(database.db_name))
        instance_class              = database.instance_class
        kms_key_id                  = database.aws_kms_alias
        max_allocated_storage       = database.max_allocated_storage
        password                    = database.password
        #region                     = < This is set statically >
        skip_final_snapshot         = database.skip_final_snapshot
        storage_encrypted           = true
        storage_type                = try(database.storage_type, "gp3")
        username                    = database.username

        tags = merge(
          # Overwriteable Default Tags
          {
            Backup       = try(database.tags["Backup"],       "True")
          },
          database.tags,
          # Non-Overwritable Default Tags
          {
            Name         = "${database.db_name}"
            Environment  = "${var.environment}"
            Terraform    = "True"
          }
        )
      }
      # Normalize 'region' variable input to align with Terraform best practices.
      if replace(database.region,"-","_") == region
    }
  }

}
