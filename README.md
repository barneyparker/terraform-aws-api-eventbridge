# terraform-aws-api-eventbridge

Module to simplify EventBridge service integrations with API Gateway routes.

## Compatibility

This module is HCL2 compatible only.

## Example

```
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_api_gateway_rest_api" "api" {
  name = "api_eventbridge"
}

module "api-eventbridge" {
  source = "barneyparker/api-eventbridge/aws"

  name        = "eventbridge"
  api_id      = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_rest_api.api.root_resource_id

  http_method = "POST"

  bus_arn  = "arn:aws:events:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:event-bus/default"
  bus_name = "default"

  event_source      = "api_eventbridge"
  event_detail_type = "Example Event"
  event_detail = {
    "request_id" = "$context.requestId",
    "email"      = "$input.path('$.email')",
    "name"       = "$input.path('$.name')",
    "message"    = "$input.path('$.message')",
    "timestamp"  = "$context.requestTimeEpoch"
  }

  responses = [
    {
      status_code       = "200"
      selection_pattern = "200"
      templates = {
        "application/json" = jsonencode({
          statusCode = 200
          message    = "OK"
        })
      }
    },
    {
      status_code       = "400"
      selection_pattern = "4\\d{2}"
      templates = {
        "application/json" = jsonencode({
          statusCode = 400
          message    = "Error"
        })
      }
    }
  ]
}
```
