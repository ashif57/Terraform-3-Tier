
An ARN (Amazon Resource Name) in AWS is a unique string that identifies a specific AWS resource across all regions and accounts. It’s essential for IAM policies, API calls, and tagging because it ensures AWS knows exactly which resource you’re referring to.
enable_dns_support = true

This enables the VPC to use the Amazon-provided DNS server.

Without it, instances in the VPC cannot resolve domain names (like amazon.com or internal AWS service endpoints).

It’s essential for things like connecting to AWS services (S3, DynamoDB, etc.) via their DNS names.

enable_dns_hostnames = true

This makes sure that instances launched in the VPC get DNS hostnames (like ip-172-31-0-1.ec2.internal).

If disabled, instances only get IP addresses, not DNS names.

Required if you want your EC2 instances to be reachable by name, or if you’re using services that depend on DNS hostnames (like ALBs or Route 53).