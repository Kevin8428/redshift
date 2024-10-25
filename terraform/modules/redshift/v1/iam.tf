# Get the AmazonRedshiftAllCommandsFullAccess policy
data "aws_iam_policy" "redshift_full_access_policy" {
  name = "AmazonRedshiftAllCommandsFullAccess"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["redshift.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "redshift" {
  name               = "${var.cluster_name}-redshift-cluster"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "attach_1" {
  role       = aws_iam_role.redshift.name
  policy_arn = data.aws_iam_policy.redshift_full_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_2" {
  role       = aws_iam_role.redshift.name
  policy_arn = aws_iam_policy.redshift_s3.arn
}

resource "aws_iam_policy" "redshift_s3" {
  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:GetBucketAcl",
                "s3:GetBucketCors",
                "s3:GetEncryptionConfiguration",
                "s3:GetBucketLocation",
                "s3:ListBucket",
                "s3:ListAllMyBuckets",
                "s3:ListMultipartUploadParts",
                "s3:ListBucketMultipartUploads",
                "s3:PutObject",
                "s3:PutBucketAcl",
                "s3:PutBucketCors",
                "s3:DeleteObject",
                "s3:AbortMultipartUpload",
                "s3:CreateBucket"
            ],
            "Resource": [
                "arn:aws:s3:::*"
            ]
        }
    ]
}
EOF
}
