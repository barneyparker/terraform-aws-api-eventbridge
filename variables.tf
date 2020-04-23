variable "name" {}

variable "api_id" {}

variable "resource_id" {}

variable "http_method" {}

variable "bus_arn" {}

variable "authorization" {
  default     = "NONE"
}

variable "request_validator_id" {
  type        = string
  description = "Request Validator Id"
}

variable "method_request_parameters" {
  type        = map
  default     = {}
}

variable "model" {
  type    = string
  default = "Empty"
}

variable "integration_request_parameters" {
  type        = map
  default     = {}
}

variable "bus_name" {
}

variable "event_source" {
  type        = string
}

variable "event_detail_type" {
  type        = string
}

variable "event_detail" {
  type        = map
}

variable "responses" {
  type        = list
  default     = []
}