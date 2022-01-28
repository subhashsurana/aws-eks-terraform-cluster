resource "aws_launch_template" "workers" {
  name_prefix            = format("%s", "${var.cluster_full_name}-${var.workers_instance_type}")
# key_name               = "eks-ci-cluster"
  instance_type          = var.workers_instance_type
  image_id               = var.workers_ami_id
  vpc_security_group_ids = [aws_security_group.workers.id]
  user_data              = base64encode(local.eks_node_private_userdata)

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_type           = "gp2"
      volume_size           = var.workers_storage_size
      delete_on_termination = true
    }
  }

  monitoring {
    enabled = true
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags          = var.common_tags
  }
}