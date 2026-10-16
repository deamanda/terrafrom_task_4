data "aws_s3_bucket" "bucket" {
  bucket = "cmtr-otuokx4e-bucket-1792134168"
}

resource "aws_iam_group" "group" {
  name = "cmtr-otuokx4e-iam-group"
}

resource "aws_iam_policy" "policy" {
  name = "cmtr-otuokx4e-iam-policy"

  policy = templatefile("${path.module}/policy.json", { bucket_name = data.aws_s3_bucket.bucket.arn })
  tags = {
    Project = "cmtr-otuokx4e"
  }
}

resource "aws_iam_role" "role" {
  name = "cmtr-otuokx4e-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Project = "cmtr-otuokx4e"
  }
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "cmtr-otuokx4e-iam-instance-profile"
  role = aws_iam_role.role.name
  tags = {
    Project = "cmtr-otuokx4e"
  }
}