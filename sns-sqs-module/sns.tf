# SNS Topic
resource "aws_sns_topic" "adacontabil_topic" {
  name = "aadacontabil_topic"
}

# SNS Subscription for SQS
resource "aws_sns_topic_subscription" "adacontabil_sqs" {
  topic_arn = aws_sns_topic.adacontabil_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.adacontabil_queue.arn
}

# SNS Subscription for Email
resource "aws_sns_topic_subscription" "adacontabil_email" {
  topic_arn = aws_sns_topic.adacontabil_topic.arn
  protocol  = "email"
  endpoint  = "jnc.vip@gmail.com"
}