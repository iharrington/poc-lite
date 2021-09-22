#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "ec2"{
  name = "ec2-role"
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
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
resource "aws_iam_policy" "ec2" {
  name        = "ec2-reader"
  description = "Ec2 Read only Policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  #Policy will provide read-access to all EC2 instances -> https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ExamplePolicies_EC2.html#iam-example-read-only
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_membership
resource "aws_iam_group_membership" "ec2" {
  name = aws_iam_group.ec2.name

  users = [
    aws_iam_user.ec2.name,
  ]

  group = aws_iam_group.ec2.name
}

resource "aws_iam_group" "ec2" {
  name = "ec2-reader-group"
}

resource "aws_iam_user" "ec2" {
  name = "ec2-user"
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment
resource "aws_iam_policy_attachment" "ec2" {
  name       = "${aws_iam_policy.ec2.name}-attachment"
  users      = [aws_iam_user.ec2.name]
  roles      = [aws_iam_role.ec2.name]
  groups     = [aws_iam_group.ec2.name]
  policy_arn = aws_iam_policy.ec2.arn
}
