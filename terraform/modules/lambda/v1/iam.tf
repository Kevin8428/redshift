data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "${var.lambda_name}-lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


resource "aws_iam_role_policy_attachment" "redshift" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.redshift.arn
}

resource "aws_iam_policy" "redshift" {
  policy      = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "redshift-data:*"
            ],
            "Resource": [
                "arn:aws:redshift:us-west-2:830370670734:cluster:redshift",
                "arn:aws:redshift:us-west-2:830370670734:*",
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "redshift:*"
            ],
            "Resource": [
                "arn:aws:redshift:us-west-2:830370670734:dbname:redshift/redshift",
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
          "Effect": "Allow",
          "Action": [
            "ec2:DescribeNetworkInterfaces",
            "ec2:CreateNetworkInterface",
            "ec2:DeleteNetworkInterface",
            "ec2:DescribeInstances",
            "ec2:AttachNetworkInterface"
          ],
          "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole" {
    role       = aws_iam_role.iam_for_lambda.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}