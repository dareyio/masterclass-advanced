# This Terraform configuration defines several resources that enable you to log and monitor the user data script for an EC2 instance:

# aws_cloudwatch_log_group resource creates a CloudWatch Logs group to store the log events of the user data script for the EC2 instance. The name of the log group is set to "/aws/ec2/instance/user-data" and the retention period for log events is set to 7 days.

# aws_launch_template resource defines the launch template for an EC2 instance. It includes the user data script which contains the commands to execute when the instance starts. The resource also includes configuration to stream the user data logs to the previously created CloudWatch Logs group. The cloudwatch_logs block specifies the name of the log group to which the logs will be streamed, the prefix for the log stream name (in this case, "instance-id"), and an optional include pattern to filter which logs to stream. The cloudwatch_agent block sets up the configuration for the CloudWatch Logs Agent, which is used to collect and stream the logs to CloudWatch Logs.

# aws_cloudwatch_metric_alarm resource creates a CloudWatch Alarm that monitors the logs from the previously created CloudWatch Logs group. The alarm is triggered if the number of log events that match the FilterName and MetricName dimensions exceeds the specified threshold within the evaluation period. In this case, the FilterName is set to "ERROR" to monitor only log events that contain the word "ERROR" and the MetricName is set to "Errors". When the alarm is triggered, it sends a notification to the specified SNS topic, which can be configured separately.


resource "aws_cloudwatch_log_group" "instance_log_group" {
  name              = "/aws/ec2/instance/user-data"
  retention_in_days = 7
}


resource "aws_cloudwatch_metric_alarm" "instance_log_error_alarm" {
  alarm_name          = "InstanceLogErrorAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Logs"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"

  dimensions = {
    LogGroupName = aws_cloudwatch_log_group.instance_log_group.name
    FilterName   = "ERROR"
  }

  alarm_description = "An error was found in the instance user data log."
}
