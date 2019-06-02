resource "aws_lambda_function" "transcode_video" {
    function_name = "transcode-video"
    filename = "function-code.zip"
    role = "${aws_iam_role.lambda_s3_execution_role.arn}"
    handler = "index.handle"
    runtime = "nodejs10.x"
}
