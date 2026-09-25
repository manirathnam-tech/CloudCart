resource "aws_iam_role" "karpenter_controller" {
  name = "${var.env}-karpenter-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.default.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(aws_iam_openid_connect_provider.default.url, "https://", "")}:sub" = "system:serviceaccount:karpenter:karpenter"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "karpenter_controller" {
  name = "${var.env}-karpenter-controller-policy"
  role = aws_iam_role.karpenter_controller.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowInstanceLaunching"
        Effect   = "Allow"
        Action   = ["ec2:RunInstances", "ec2:CreateFleet", "ec2:CreateLaunchTemplate"]
        Resource = "*"
      },
      {
        Sid      = "AllowResourceTagging"
        Effect   = "Allow"
        Action   = ["ec2:CreateTags"]
        Resource = ["arn:aws:ec2:*:*:instance/*", "arn:aws:ec2:*:*:launch-template/*"]
      },
      {
        Sid      = "AllowInstanceLifecycle"
        Effect   = "Allow"
        Action   = ["ec2:TerminateInstances", "ec2:DeleteLaunchTemplate"]
        Resource = "*"
      },
      {
        Sid    = "AllowDiscovery"
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeSpotPriceHistory",
          "ec2:DescribeImages",
        ]
        Resource = "*"
      },
      {
        Sid      = "AllowPricingLookup"
        Effect   = "Allow"
        Action   = ["pricing:GetProducts"]
        Resource = "*"
      },
      {
        Sid      = "AllowSSMReadForAMIs"
        Effect   = "Allow"
        Action   = ["ssm:GetParameter"]
        Resource = "arn:aws:ssm:*::parameter/aws/service/*"
      },
      {
        Sid      = "AllowPassingNodeRole"
        Effect   = "Allow"
        Action   = ["iam:PassRole"]
        Resource = aws_iam_role.eks_node_role.arn
      },
      {
        Sid      = "AllowInstanceProfileRead"
        Effect   = "Allow"
        Action   = ["iam:GetInstanceProfile"]
        Resource = aws_iam_instance_profile.karpenter_node.arn
      },
    ]
  })
}

resource "aws_iam_instance_profile" "karpenter_node" {
  name = "${var.env}-karpenter-node-instance-profile"
  role = aws_iam_role.eks_node_role.name
}
