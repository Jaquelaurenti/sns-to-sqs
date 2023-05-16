provider "aws" {
  region = "us-east-1"
}

resource "aws_sns_topic" "sns_to_sqs" {
  name         = "sns-to-sqs"
  display_name = "SNS to SQS"
}

resource "aws_sqs_queue" "sns_to_sqs" {
  name = "sns-to-sqs"
}

resource "aws_sns_topic_subscription" "my_subscription" {
  topic_arn = aws_sns_topic.sns_to_sqs.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.sns_to_sqs.arn
}

resource "aws_sqs_queue_policy" "access_policy" {
  queue_url = aws_sqs_queue.sns_to_sqs.url

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Allow-SNS-to-Publish-to-SQS"
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.sns_to_sqs.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.sns_to_sqs.arn
          }
        }
      }
    ]
  })
}