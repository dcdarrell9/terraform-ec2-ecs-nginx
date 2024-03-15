# terraform-ec2-ecs-nginx

- Decide on where you want this to run.
- Ideally a module would be pulled and used with a source and a version, but quick custom code should sit in a `modules` folder for easy development.
- If running alongside other code, use `-target` so that you can apply/destroy without affecting other resources.
- It is currently set up to use `10.0.0.0` as the VPC/CIDR block, if that causes clashes, it will need some code changes.
- The EC2 service is a bit more thorough than the ECS, ECS can just be pinged with the default.
- Was going to add certificates, but didn't.
- Some policies are slightly broad.
- Cloudwatch dashboards in TF are not nice.


# Example
```
data "aws_caller_identity" "current" {}

module "test_module {
  source = "../modules/test_module"

  account_id         = data.aws_caller_identity.current.account_id
  environment        = "dev"
  aws_region         = "eu-west-2"
  availability_zones = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}
```
