resource "aws_autoscaling_group" "terraform_asg" {
  name             = "my-terraform-asg"   # This is the name of the ASG that will be created in AWS
  min_size         = var.min_size         # Reference the variable 'min_size' to define the lower bound of the ASG size
  max_size         = var.max_size         # Reference the variable 'max_size' to define the upper bound of the ASG size
  desired_capacity = var.desired_capacity # Reference the variable 'desired_capacity' to set the number of instances at the start
  #availability_zones = var.avilablity_zones # Reference the variable 'availability_zones' to define where to deploy instances in different zones
  vpc_zone_identifier = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id] # Specify the subnets where the ASG will launch instances
  # Define the launch template used by the ASG for creating instances
  launch_template {
    id      = aws_launch_template.launch-asg.id # Reference the ID of the launch template defined elsewhere in your configuration
    version = "$Latest"                         # Use the latest version of the launch template when launching instances
  }

  target_group_arns = [aws_lb_target_group.alb_tg.arn] # Reference the ARN of the target group for load balancing
  health_check_type = "ELB"                            # Specify that the health check type for the ASG is based on the Elastic Load Balancer (ELB)

  # Tag the ASG to help identify it in the AWS Management Console
  tag {
    key                 = "Name"
    value               = "webserver" # Tag value to be applied to instances launched by the ASG
    propagate_at_launch = true            # Ensure that this tag is propagated to instances when they are launched
  }
}

resource "aws_launch_template" "launch-asg" {
  name          = "my-launch-asg"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  depends_on    = [aws_nat_gateway.ev_nat]
  user_data     = base64encode(file("${path.module}/userdata.sh"))
  #user_data     = base64encode(file("install_apache.sh")) # Explicit encoding of user data

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.webserver_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "MyLaunchASGInstance"
    }
  }
}