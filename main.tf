module "eventbridge_integration" {
  source = "github.com/barneyparker/terraform-aws-api-generic"

  name               = var.name
  api_id             = var.api_id
  resource_id        = var.resource_id
  http_method        = var.http_method
  authorization      = var.authorization
  method_request_parameters = var.method_request_parameters

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:eu-west-1:events:action/PutEvents"
  credentials             = aws_iam_role.eventbridge_put.arn

  request_validator_id = var.request_validator_id

  model = var.model

  integration_request_parameters = merge(var.integration_request_parameters, {
    "integration.request.header.X-Amz-Target" = "'AWSEvents.PutEvents'"
    "integration.request.header.Content-Type" = "'application/x-amz-json-1.1'"
  })

  request_templates = {
    "application/json" = <<-EOT
      {
        "Entries": [
          {
            "EventBusName":"${var.bus_name}",
            "Source":"${var.event_source}",
            "DetailType":"${var.event_detail_type}",
            "Detail": "${replace(replace(jsonencode(var.event_detail), "\"", "\\\""), "\n", "")}",
            "Resources": [],
            "Time": $context.requestTimeEpoch
          }
        ]
      }
    EOT
  }

  responses = var.responses
}

resource "aws_iam_role" "eventbridge_put" {
  name = "${var.name}-eventbridge-put"
  assume_role_policy = data.aws_iam_policy_document.apigw.json
}

data "aws_iam_policy_document" "apigw" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "apigateway.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role_policy" "eventbridge_put" {
  name = "Event-Bus-Put-Item"
  role = aws_iam_role.eventbridge_put.id
  policy = data.aws_iam_policy_document.eventbridge_put.json
}

data "aws_iam_policy_document" "eventbridge_put" {
  statement {
     actions = [
      "events:*",
    ]

    resources = [
      "${var.bus_arn}",
    ]
  }
}