# Create assume Role for EC2 to use EBS
resource "aws_iam_role" "Build-Serveriamrole" {
  name = "Build-Serveriamrole"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      tag-key = "Build-Serveriamrole"
  }
}
# Create an EC2 intance profile
resource "aws_iam_instance_profile" "Build-Server-profile" {
  name = "Build-Server-profile"
  role = "${aws_iam_role.Build-Serveriamrole.name}"
}

#Adding IAM policy to give full access to EC2
resource "aws_iam_role_policy" "Build-Server-policy" {
  name = "Build-Server-policy"
  role = "${aws_iam_role.Build-Serveriamrole.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
                "elasticloadbalancing:DescribeInstanceHealth",
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticloadbalancing:DescribeTargetHealth",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceStatus",
                "ec2:GetConsoleOutput",
                "ec2:AssociateAddress",
                "ec2:DescribeAddresses",
                "ec2:DescribeSecurityGroups",
                "sqs:GetQueueAttributes",
                "sqs:GetQueueUrl",
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeScalingActivities",
                "autoscaling:DescribeNotificationConfigurations",
                "sns:Publish"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# Attach this Role to the EC2 Instance