output "kinesis_stream_name" {
  description = "The Kinesis Data Stream name"
  value       = aws_kinesis_stream.test_stream.name
}


output "state_machine_status" {
  description = "The current status of the State Machine"
  value       = aws_sfn_state_machine.stateMachine.status
}

output "state_machine_id" {
  description = "The ARN of the State Machine"
  value       = aws_sfn_state_machine.stateMachine.id
}

output "state_machine_arn" {
  description = "The ARN of the State Machine"
  value       = aws_sfn_state_machine.stateMachine.arn
}
