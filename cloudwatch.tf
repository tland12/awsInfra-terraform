resource "aws_cloudwatch_metric_alarm" "cloud-watch" {
  alarm_name          = "cloud-watch"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "RequestCount"
  namespace           = "AWS/ELB"
  period              = 300
  statistic           = "Sum"
  threshold           = 60
  alarm_description   = "This metric monitors ASG's traffic"
  datapoints_to_alarm = 1
  dimensions = {
  }
  insufficient_data_actions = []
  alarm_actions = [
    aws_sns_topic.asg_alarms.arn,
  ]
}

resource "aws_cloudwatch_log_group" "asg_logs" {
  name              = "aws_elb"
  retention_in_days = 7
}

# EKS WorkerNodeGroup Log
resource "aws_cloudwatch_log_stream" "asg_worker_nodes" {
  log_group_name = aws_cloudwatch_log_group.asg_logs.name
  name           = "worker-nodes"
}

# SNS Alarm Topic
resource "aws_sns_topic" "asg_alarms" {
  name = "asg-alarms"
}

# SNS Alarm Subscription
resource "aws_sns_topic_subscription" "asg_alarms_email" {
  topic_arn = aws_sns_topic.asg_alarms.arn
  protocol  = "email"
  endpoint  = "tland12@naver.com"
}

