terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.9.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.2.0"
    }
  }
}


provider "aws" {
  region                      =var.myregion 
  access_key                  = "fake"    #credential
  secret_key                  = "fake"     #credential
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true
  # insecure_skip_verification  = true
  endpoints {
      dynamodb                = "http://localhost:4566"
      lambda                  = "http://localhost:4566"
      s3                      = "http://localhost:4566"
      iam                     = "http://localhost:4566"  
      kinesis                 = "http://localhost:4566" 
      firehose                = "http://localhost:4566"
      cloudwatch              = "http://localhost:4566"
      cloudwatchevents        = "http://localhost:4566"
      stepfunctions           = "http://localhost:4566"
  }
}

