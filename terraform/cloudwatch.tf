resource "aws_cloudwatch_event_rule" "schedule_states" {
  description         = "Start step function execution"
  name                = "${local.project_name}-schedulesfn"
  schedule_expression = "cron(0 9 * * ? *)"
  depends_on = [ aws_sfn_state_machine.example-stepfunction ]
}

resource "aws_cloudwatch_event_target" "states_target" {
  rule     = aws_cloudwatch_event_rule.schedule_states.id
  arn      = aws_sfn_state_machine.example-stepfunction.id
  role_arn = aws_iam_role.step_function_role.arn

  depends_on = [ aws_cloudwatch_event_rule.schedule_states ]
}

