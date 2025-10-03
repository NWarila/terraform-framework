#% =========================================================================================== %#
#% = File: 52-aws-resources.tf                                   | Category: Resources (50-59) %#
#% ----- [ Description ] --------------------------------------------------------------------- %#
#% Resources are the most important element in the Terraform language. Each resource block     %#
#%   describes one or more infrastructure objects, such as virtual networks, compute           %#
#%   instances, or higher-level components such as DNS records.                                %#
#% =========================================================================================== %#


#region ------ [ Create All Elastic Network Interfaces (ENIs) ] ------------------------------- #

  #region ------ [ Create All Elastic Network Interfaces (ENIs) - US-ISO-WEST-1 ] ------------- #

  resource "aws_network_interface" "us_iso_west_1" {

    # Itterate through all network interfaces in the target region.
    for_each = local.elastic_network_interfaces.us_iso_west_1

    # Set the provider in which to deploy the instance.
    provider = aws.us_iso_west_1

    # Define the Network Interface Properties
    subnet_id       = each.value.subnet_id
    description     = each.value.description
    interface_type  = each.value.interface_type
    private_ips     = each.value.private_ips
    security_groups = each.value.security_groups
    tags            = each.value.tags

  }

  #endregion --- [ Create All Elastic Network Interfaces (ENIs) - US-ISO-WEST-1 ] ------------- #

  #region ------ [ Create All Elastic Network Interfaces (ENIs) - US-ISO-EAST-1 ] ------------- #

  resource "aws_network_interface" "us_iso_east_1" {

    # Itterate through all network interfaces in the target region.
    for_each = local.elastic_network_interfaces.us_iso_east_1

    # Set the provider in which to deploy the instance.
    provider = aws.us_iso_east_1

    # Define the Network Interface Properties
    subnet_id       = each.value.subnet_id
    description     = each.value.description
    interface_type  = each.value.interface_type
    private_ips     = each.value.private_ips
    security_groups = each.value.security_groups
    tags            = each.value.tags

  }

  #endregion --- [ Create All Elastic Network Interfaces (ENIs) - US-ISO-EAST-1 ] ------------- #

#endregion --- [ Create All Elastic Network Interfaces (ENIs) ] ------------------------------- #


#region ------ [ Create All Elastic Block Store (EBS) Objects ] ------------------------------- #

  #region ------ [ Create All Elastic Block Store (EBS) Objects - US-ISO-WEST-1 ] ------------- #

  resource "aws_ebs_volume" "us_iso_west_1" {

    # Itterate through all network interfaces in the target region.
    for_each = {
      for k, v in local.ebs_block_devices.us_iso_west_1: k => v
      if v.refresh == false
    }

    # Set the provider in which to deploy the instance.
    provider = aws.us_iso_west_1

    # Define the Elastic Block Store Properties
    availability_zone     = each.value.availability_zone
    encrypted             = each.value.encrypted
    iops                  = each.value.iops
    kms_key_id            = data.aws_kms_alias.us_iso_west_1[each.value.kms_key_id].target_key_arn
    snapshot_id           = each.value.snapshot_id
    tags                  = each.value.tags
    throughput            = each.value.throughput
    size                  = each.value.volume_size
    type                  = each.value.volume_type

  }

  resource "aws_ebs_volume" "us_iso_west_1_refresh" {

    # Itterate through all network interfaces in the target region.
    for_each = {
      for k, v in local.ebs_block_devices.us_iso_west_1: k => v
      if v.refresh == true
    }

    # Set the provider in which to deploy the instance.
    provider = aws.us_iso_west_1

    # Define the Elastic Block Store Properties
    availability_zone     = each.value.availability_zone
    encrypted             = each.value.encrypted
    iops                  = each.value.iops
    kms_key_id            = data.aws_kms_alias.us_iso_west_1[each.value.kms_key_id].target_key_arn
    snapshot_id           = each.value.snapshot_id
    tags                  = each.value.tags
    throughput            = each.value.throughput
    size                  = each.value.volume_size
    type                  = each.value.volume_type

  }

  #endregion --- [ Create All Elastic Block Store (EBS) Objects - US-ISO-WEST-1 ] ------------- #

  #region ------ [ Create All Elastic Block Store (EBS) Objects - US-ISO-EAST-1 ] ------------- #

  resource "aws_ebs_volume" "us_iso_east_1" {

    # Itterate through all network interfaces in the target region.
    for_each = {
      for k, v in local.ebs_block_devices.us_iso_east_1: k => v
      if v.refresh == true
    }

    # Set the provider in which to deploy the instance.
    provider = aws.us_iso_east_1

    # Define the Elastic Block Store Properties
    availability_zone     = each.value.availability_zone
    encrypted             = each.value.encrypted
    iops                  = each.value.iops

    snapshot_id           = each.value.snapshot_id
    tags                  = each.value.tags
    throughput            = each.value.throughput
    size                  = each.value.volume_size
    type                  = each.value.volume_type

    # ?Note: Using the lookup function, search inside the 'local.all_kms_keys' object map for a
    # ?  object with the key matching the value of 'system.aws_kms_alias'.
    kms_key_id = data.aws_kms_alias.us_iso_east_1[each.value.kms_key_id].target_key_arn

  }

  resource "aws_ebs_volume" "us_iso_east_1_refresh" {

    # Itterate through all network interfaces in the target region.
    for_each = {
      for k, v in local.ebs_block_devices.us_iso_east_1: k => v
      if v.refresh == true
    }

    # Set the provider in which to deploy the instance.
    provider = aws.us_iso_east_1

    # Define the Elastic Block Store Properties
    availability_zone     = each.value.availability_zone
    encrypted             = each.value.encrypted
    iops                  = each.value.iops

    snapshot_id           = each.value.snapshot_id
    tags                  = each.value.tags
    throughput            = each.value.throughput
    size                  = each.value.volume_size
    type                  = each.value.volume_type

    # ?Note: Using the lookup function, search inside the 'local.all_kms_keys' object map for a
    # ?  object with the key matching the value of 'system.aws_kms_alias'.
    kms_key_id = data.aws_kms_alias.us_iso_east_1[each.value.kms_key_id].target_key_arn

  }

  #endregion --- [ Create All Elastic Block Store (EBS) Objects - US-ISO-WEST-1 ] ------------- #

#endregion --- [ Create All Elastic Block Store (EBS) Objects ] ------------------------------- #


#region ------ [ Create All Elastic Computer Cloud (EC2s) ] ----------------------------------- #

resource "aws_instance" "us_iso_west_1" {

  # Set the provider in which to deploy the instance.
  provider = aws.us_iso_west_1

  # Itterate through all network interfaces in the target region.
  for_each = {
    for k, v in local.elastic_compute_cloud.us_iso_west_1: k => v
    if v.refresh == false
  }

    ami                     = local.amazon_machine_images[each.value.ami]["us_iso_west_1"].id
    instance_type           = each.value.instance_type
    availability_zone       = each.value.availability_zone
    tags                    = each.value.tags
    key_name                = data.aws_key_pair.us_iso_west_1[each.value.key_name].key_name

    root_block_device {
      volume_type           = each.value.root_block_device.volume_type
      volume_size           = each.value.root_block_device.volume_size
      encrypted             = each.value.root_block_device.encrypted
      delete_on_termination = each.value.root_block_device.delete_on_termination
      tags                  = each.value.root_block_device.tags
      kms_key_id            = (
        data.aws_kms_alias.us_iso_west_1[each.value.root_block_device.kms_key_id].target_key_arn
      )
    }

    # ?Note: Network interface(s) need to be attached on creation otherwise a default interface
    # ?  will be created reguardless of what else has been configured, and network interfaces
    # ?  can only be attached while the system is powered off causing serious workflow issues.
    dynamic "network_interface" {
      for_each = {
        for network_interface in aws_network_interface.us_iso_west_1 :
          network_interface.id => network_interface
        if network_interface.tags.Name == each.value.hostname
      }
      content {
        delete_on_termination = false
        device_index          = network_interface.value.tags.Index
        network_card_index    = network_interface.value.tags.Index
        network_interface_id  = network_interface.value.id
      }
    }

    # Wait until system is both booted & finished running user-data.
    # This no longer works since we included windows support. Will need Workaround.
    # provisioner "remote-exec" {
    #   inline = [
    #     "cloud-init status --wait"
    #   ]
    # }

    # ?Note: Volumes created with ebs_block_device and have 'delete_on_termination = false'
    # ?  configured will not automatically reattach the volume when the EC2 instance is
    # ?  recreated, it will just abandon the volume and create/attach a new volume.
    # dynamic "ebs_block_device" {}

}

resource "aws_instance" "us_iso_west_1_refresh" {

  # Set the provider in which to deploy the instance.
  provider = aws.us_iso_west_1

  # Itterate through all network interfaces in the target region.
  for_each = {
    for k, v in local.elastic_compute_cloud.us_iso_west_1: k => v
    if v.refresh == true
  }

    ami                     = local.amazon_machine_images[each.value.ami]["us_iso_west_1"].id
    instance_type           = each.value.instance_type
    availability_zone       = each.value.availability_zone
    tags                    = each.value.tags
    key_name                = data.aws_key_pair.us_iso_west_1[each.value.key_name].key_name

    root_block_device {
      volume_type           = each.value.root_block_device.volume_type
      volume_size           = each.value.root_block_device.volume_size
      encrypted             = each.value.root_block_device.encrypted
      delete_on_termination = each.value.root_block_device.delete_on_termination
      tags                  = each.value.root_block_device.tags
      kms_key_id            = (
        data.aws_kms_alias.us_iso_west_1[each.value.root_block_device.kms_key_id].target_key_arn
      )
    }

    # ?Note: Network interface(s) need to be attached on creation otherwise a default interface
    # ?  will be created reguardless of what else has been configured, and network interfaces
    # ?  can only be attached while the system is powered off causing serious workflow issues.
    dynamic "network_interface" {
      for_each = {
        for network_interface in aws_network_interface.us_iso_west_1 :
          network_interface.id => network_interface
        if network_interface.tags.Name == each.value.hostname
      }
      content {
        delete_on_termination = false
        device_index          = network_interface.value.tags.Index
        network_card_index    = network_interface.value.tags.Index
        network_interface_id  = network_interface.value.id
      }
    }

    # ?Note: Volumes created with ebs_block_device and have 'delete_on_termination = false'
    # ?  configured will not automatically reattach the volume when the EC2 instance is
    # ?  recreated, it will just abandon the volume and create/attach a new volume.
    # dynamic "ebs_block_device" {}

    lifecycle {
      replace_triggered_by = [
        terraform_data.refresh
      ]
    }

}

resource "aws_instance" "us_iso_east_1" {

  # Set the provider in which to deploy the instance.
  provider = aws.us_iso_east_1

  # Itterate through all network interfaces in the target region.
  for_each = {
    for k, v in local.elastic_compute_cloud.us_iso_east_1: k => v
    if v.refresh == false
  }

    ami                     = each.value.ami
    instance_type           = each.value.instance_type
    availability_zone       = each.value.availability_zone
    tags                    = each.value.tags
    key_name                = data.aws_key_pair.us_iso_west_1[each.value.key_name].key_name

    root_block_device {
      volume_type           = each.value.root_block_device.volume_type
      volume_size           = each.value.root_block_device.volume_size
      encrypted             = each.value.root_block_device.encrypted
      delete_on_termination = each.value.root_block_device.delete_on_termination
      tags                  = each.value.root_block_device.tags
      kms_key_id            = (
        data.aws_kms_alias.us_iso_east_1[each.value.root_block_device.kms_key_id].target_key_arn
      )
    }

    # ?Note: Network interface(s) need to be attached on creation otherwise a default interface
    # ?  will be created reguardless of what else has been configured, and network interfaces
    # ?  can only be attached while the system is powered off causing serious workflow issues.
    dynamic "network_interface" {
      for_each = {
        for network_interface in aws_network_interface.us_iso_east_1 :
          network_interface.id => network_interface
        if network_interface.tags.Name == each.value.hostname
      }
      content {
        delete_on_termination = false
        device_index          = network_interface.value.tags.Index
        network_card_index    = network_interface.value.tags.Index
        network_interface_id  = network_interface.value.id
      }
    }

    # Wait until system is both booted & finished running user-data.
    # This no longer works since we included windows support. Will need Workaround.
    # provisioner "remote-exec" {
    #   inline = [
    #     "cloud-init status --wait"
    #   ]
    # }

    # ?Note: Volumes created with ebs_block_device and have 'delete_on_termination = false'
    # ?  configured will not automatically reattach the volume when the EC2 instance is
    # ?  recreated, it will just abandon the volume and create/attach a new volume.
    # dynamic "ebs_block_device" {}

}

resource "aws_instance" "us_iso_east_1_refresh" {

  # Set the provider in which to deploy the instance.
  provider = aws.us_iso_east_1

  # Itterate through all network interfaces in the target region.
  for_each = {
    for k, v in local.elastic_compute_cloud.us_iso_east_1: k => v
    if v.refresh == true
  }

    ami                     = each.value.ami
    instance_type           = each.value.instance_type
    availability_zone       = each.value.availability_zone
    tags                    = each.value.tags
    key_name                = data.aws_key_pair.us_iso_west_1[each.value.key_name].key_name

    root_block_device {
      volume_type           = each.value.root_block_device.volume_type
      volume_size           = each.value.root_block_device.volume_size
      encrypted             = each.value.root_block_device.encrypted
      delete_on_termination = each.value.root_block_device.delete_on_termination
      tags                  = each.value.root_block_device.tags
      kms_key_id            = (
        data.aws_kms_alias.us_iso_east_1[each.value.root_block_device.kms_key_id].target_key_arn
      )
    }

    # ?Note: Network interface(s) need to be attached on creation otherwise a default interface
    # ?  will be created reguardless of what else has been configured, and network interfaces
    # ?  can only be attached while the system is powered off causing serious workflow issues.
    dynamic "network_interface" {
      for_each = {
        for network_interface in aws_network_interface.us_iso_east_1 :
          network_interface.id => network_interface
        if network_interface.tags.Name == each.value.hostname
      }
      content {
        delete_on_termination = false
        device_index          = network_interface.value.tags.Index
        network_card_index    = network_interface.value.tags.Index
        network_interface_id  = network_interface.value.id
      }
    }

    # ?Note: Volumes created with ebs_block_device and have 'delete_on_termination = false'
    # ?  configured will not automatically reattach the volume when the EC2 instance is
    # ?  recreated, it will just abandon the volume and create/attach a new volume.
    # dynamic "ebs_block_device" {}

    lifecycle {
      replace_triggered_by = [
        terraform_data.refresh
      ]
    }

}

#endregion --- [ Create All Elastic Computer Cloud (EC2s) ] ----------------------------------- #


#region ------ [ Attach All Elastic Block Store (EBS) Volumes ] ------------------------------- #

  #region ------ [ Attach All Elastic Block Store (EBS) Volumes - US-ISO-WEST-1 ] ------------- #

  resource "aws_volume_attachment" "us_iso_west_1" {

    # Set the provider in which to deploy the instance.
    provider = aws.us_iso_west_1

    # Itterate through all Elastic Block Storeage (EBS) volumes in the target region.
    for_each = aws_ebs_volume.us_iso_west_1

      skip_destroy = (
        local.ebs_block_devices.us_iso_west_1["${each.value.tags.Name}-ebs-${each.value.tags.Index}"].delete_on_termination
      )
      instance_id  = aws_instance.us_iso_west_1[ each.value.tags.Name ].id
      volume_id    = each.value.id
      device_name  = each.value.tags.DeviceName

  }

  resource "aws_volume_attachment" "us_iso_west_1_refresh" {

    # Set the provider in which to deploy the instance.
    provider = aws.us_iso_west_1

    # Itterate through all Elastic Block Storeage (EBS) volumes in the target region.
    for_each = aws_ebs_volume.us_iso_west_1_refresh

      skip_destroy = (
        local.ebs_block_devices.us_iso_west_1["${each.value.tags.Name}-ebs-${each.value.tags.Index}"].delete_on_termination
      )
      instance_id  = aws_instance.us_iso_west_1_refresh[ each.value.tags.Name ].id
      volume_id    = each.value.id
      device_name  = each.value.tags.DeviceName

  }

  #endregion --- [ Attach All Elastic Block Store (EBS) Volumes - US-ISO-WEST-1 ] ------------- #

  #region ------ [ Attach All Elastic Block Store (EBS) Volumes - US-ISO-EAST-1 ] ------------- #

  resource "aws_volume_attachment" "us_iso_east_1" {

    # Set the provider in which to deploy the instance.
    provider = aws.us_iso_east_1

    # Itterate through all Elastic Block Storeage (EBS) volumes in the target region.
    for_each = aws_ebs_volume.us_iso_east_1

      skip_destroy = (
        local.ebs_block_devices.us_iso_east_1["${each.value.tags.Name}-ebs-${each.value.tags.Index}"].delete_on_termination
      )
      instance_id  = aws_instance.us_iso_east_1[ each.value.tags.Name ].id
      volume_id    = each.value.id
      device_name  = each.value.tags.DeviceName

  }

  resource "aws_volume_attachment" "us_iso_east_1_refresh" {

    # Set the provider in which to deploy the instance.
    provider = aws.us_iso_east_1

    # Itterate through all Elastic Block Storeage (EBS) volumes in the target region.
    for_each = aws_ebs_volume.us_iso_east_1_refresh

      skip_destroy = (
        local.ebs_block_devices.us_iso_east_1["${each.value.tags.Name}-ebs-${each.value.tags.Index}"].delete_on_termination
      )
      instance_id  = aws_instance.us_iso_east_1_refresh[ each.value.tags.Name ].id
      volume_id    = each.value.id
      device_name  = each.value.tags.DeviceName

  }

  #endregion --- [ Attach All Elastic Block Store (EBS) Volumes - US-ISO-WEST-1 ] ------------- #

#endregion --- [ Attach All Elastic Block Store (EBS) Volumes ] ------------------------------- #


#region ------ [ Create Relational Database Service (RDS) ] ----------------------------------- #

resource "aws_db_instance" "us_iso_west_1" {

  # Set the provider in which to deploy the instance.
  provider = aws.us_iso_west_1

  # Itterate through all network interfaces in the target region.
  for_each = local.relational_database_service.us_iso_west_1

    allocated_storage           = each.value.allocated_storage
    availability_zone           = each.value.availability_zone
    backup_retention_period     = each.value.backup_retention_period
    backup_window               = each.value.backup_window
    #blue_green_update           = each.value.blue_green_update
    ca_cert_identifier          = each.value.ca_cert_identifier
    db_name                     = each.value.db_name
    db_subnet_group_name        = each.value.db_subnet_group_name
    dedicated_log_volume        = each.value.dedicated_log_volume
    delete_automated_backups    = each.value.delete_automated_backups
    deletion_protection         = each.value.deletion_protection
    engine                      = each.value.engine
    engine_version              = each.value.engine_version
    final_snapshot_identifier   = each.value.final_snapshot_identifier
    identifier                  = each.value.identifier
    instance_class              = each.value.instance_class
    max_allocated_storage       = each.value.max_allocated_storage
    password                    = each.value.password
    skip_final_snapshot         = each.value.skip_final_snapshot
    storage_encrypted           = each.value.storage_encrypted
    storage_type                = each.value.storage_type
    username                    = each.value.username

    kms_key_id = data.aws_kms_alias.us_iso_west_1[each.value.kms_key_id].target_key_arn

}


resource "aws_db_instance" "us_iso_east_1" {

  # Set the provider in which to deploy the instance.
  provider = aws.us_iso_east_1

  # Itterate through all network interfaces in the target region.
  for_each = local.relational_database_service.us_iso_east_1

    allocated_storage           = each.value.allocated_storage
    availability_zone           = each.value.availability_zone
    backup_retention_period     = each.value.backup_retention_period
    backup_window               = each.value.backup_window
    #blue_green_update           = each.value.blue_green_update
    ca_cert_identifier          = each.value.ca_cert_identifier
    db_name                     = each.value.db_name
    db_subnet_group_name        = each.value.db_subnet_group_name
    dedicated_log_volume        = each.value.dedicated_log_volume
    delete_automated_backups    = each.value.delete_automated_backups
    deletion_protection         = each.value.deletion_protection
    engine                      = each.value.engine
    engine_version              = each.value.engine_version
    final_snapshot_identifier   = each.value.final_snapshot_identifier
    identifier                  = each.value.identifier
    instance_class              = each.value.instance_class
    max_allocated_storage       = each.value.max_allocated_storage
    password                    = each.value.password
    skip_final_snapshot         = each.value.skip_final_snapshot
    storage_encrypted           = each.value.storage_encrypted
    storage_type                = each.value.storage_type
    username                    = each.value.username

    kms_key_id = data.aws_kms_alias.us_iso_east_1[each.value.kms_key_id].target_key_arn

}

#endregion --- [ Create Relational Database Service (RDS) ] ----------------------------------- #


#region ------ [ Configure EC2 Instance State ] ----------------------------------------------- #

  resource "aws_ec2_instance_state" "us_iso_west_1" {

    # Set the provider in which to deploy the instance.
    provider = aws.us_iso_west_1

    # Itterate through all EC2 instances in 'us-iso-west-1' where 'set_state' is defined.
    for_each = {
      for hostname, system in aws_instance.us_iso_west_1: hostname => system
        if can(local.elastic_compute_cloud["us_iso_west_1"][hostname].set_state)
    }

    instance_id = each.value.id
    state = local.elastic_compute_cloud["us_iso_west_1"][each.key].set_state

  }

  resource "aws_ec2_instance_state" "us_iso_east_1" {

    # Set the provider in which to deploy the instance.
    provider = aws.us_iso_east_1

    # Itterate through all EC2 instances in 'us-iso-east-1' where 'set_state' is defined.
    for_each = {
      for hostname, system in aws_instance.us_iso_east_1: hostname => system
        if can(local.elastic_compute_cloud["us_iso_east_1"][hostname].set_state)
    }

    instance_id = each.value.id
    state = local.elastic_compute_cloud["us_iso_east_1"][each.key].set_state

  }

#endregion --- [ Configure EC2 Instance State ] ----------------------------------------------- #
