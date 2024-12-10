resource "aws_sns_topic" "sns_adacontabil" {
  name = "sns-adacontabil"

  tags = {
    Name = "SNS Ada Contabil"
  }
}

resource "aws_sns_topic_subscription" "sns_subscription_sqs" {
  topic_arn = aws_sns_topic.sns_adacontabil.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.sqs_adacontabil.arn

  depends_on = [aws_sqs_queue_policy.sqs_policy]
}

resource "aws_sns_topic_subscription" "topic_subscription" {
  topic_arn = aws_sns_topic.sns_adacontabil.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.lambda_sns.arn

  depends_on = [aws_lambda_permission.lambada_sns]
}



# resource "aws_sns_topic_subscription" "sns_subscription_email" {
#   topic_arn = aws_sns_topic.sns_projetofinal.arn
#   protocol  = "email"
#   endpoint  = var.email
# }

# resource "aws_sns_topic_subscription" "sns_sbiscription_sms" {
#   topic_arn = aws_sns_topic.sns_projetofinal.arn
#   protocol  = "sms"
#   endpoint  = var.phone
# }