###############################################################################
# AWS Managed Instance Role
###############################################################################
resource "aws_iam_role" "default" {
  name = local.name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "ec2.amazonaws.com",
            "ssm.amazonaws.com"
          ]
        }
      },
    ]
  })

  tags = local.tags
}

data "aws_iam_policy" "ssm" {
  name = "AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.default.name
  policy_arn = data.aws_iam_policy.ssm.arn
}

data "aws_iam_policy" "cw" {
  name = "CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "cw" {
  role       = aws_iam_role.default.name
  policy_arn = data.aws_iam_policy.cw.arn
}

# #############################################################################
# Prepare User Data for Cloud Init
# #############################################################################
data "external" "get_session_token" {
  program = ["bash", "${path.module}/scripts/get_session_token.sh"]
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/user_data.tpl")
  vars = {
    aws_access_key_id     = data.external.get_session_token.result.access_key
    aws_secret_access_key = data.external.get_session_token.result.secret_key
    aws_session_token     = data.external.get_session_token.result.session_token
    description           = local.description
    domain                = local.domain
    hostname              = local.name
    log_group_name        = "/${var.GIT_REPOSITORY}/${local.name}"
    region                = data.aws_region.default.name
    role                  = aws_iam_role.default.name
    salt_environment      = local.salt_environment
    salt_role             = local.salt_role
    saltmaster            = var.SALTMASTER
    tags                  = join(" ", [ for key, value in local.tags : "\"Key=${key},Value=${value}\"" ])
  }
}

# #############################################################################
# Send User Data for Cloud Init to Proxmox Host
# #############################################################################
resource "null_resource" "user_data" {
  connection {
    type     = "ssh"
    user     = var.PVE_USER
    password = var.PVE_PASSWORD
    host     = var.PVE_HOST
  }

  triggers = {
    file = sha256(data.template_file.user_data.rendered)
  }

  provisioner "file" {
    content  = data.template_file.user_data.rendered
    destination = "/var/lib/vz/snippets/${sha256(data.template_file.user_data.rendered)}.cfg"
  }
}

# #############################################################################
# Provision Kubernetes Virtual Machine
# #############################################################################
resource "proxmox_vm_qemu" "default" {
  cicustom                = "user=local:snippets/${sha256(data.template_file.user_data.rendered)}.cfg"
  cloudinit_cdrom_storage = "local"
  clone                   = local.golden_image
  cores                   = 4
  desc                    = local.description
  full_clone              = true
  ipconfig0               = "ip=dhcp"
  memory                  = 4096
  name                    = local.name
  os_type                 = "cloud-init"
  pool                    = var.PVE_POOL
  sockets                 = 2
  target_node             = var.PVE_NODE

  disk {
    size      = "25G"
    storage   = "local"
    type      = "virtio"
  }

  network {
    model     = "e1000"
    bridge    = "vmbr0"
   }

  depends_on  = [
    null_resource.user_data,
  ]
}
