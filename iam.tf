resource "aws_iam_user" "lambda_upload" {
    name = "lambda-upload"
}

resource "aws_iam_access_key" "lambda_upload_access" {
    user = "${aws_iam_user.lambda_upload.name}"
}

resource "aws_iam_policy" "lambda_upload_policy" {
  name = "lambda-upload-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "lambda:UpdateFunctionCode",
                "lambda:GetFunction",
                "lambda:UpdateFunctionConfiguration"
            ],
            "Resource": "arn:aws:lambda:*:*:function:*"
        }
    ]
}
  EOF
}

resource "aws_iam_role" "lambda_s3_execution_role" {
  name = "lambda-s3-execution-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
  EOF
}

data "aws_iam_policy" "AWSLambdaExecute" {
    arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

data "aws_iam_policy" "AmazonElasticTranscoderJobsSubmitter" {
    arn = "arn:aws:iam::aws:policy/AmazonElasticTranscoder_JobsSubmitter"
}

resource "aws_iam_role_policy_attachment" "lambda_s3_execution_role_attachment_execute" {
  role = "${aws_iam_role.lambda_s3_execution_role.name}"
  policy_arn = "${data.aws_iam_policy.AWSLambdaExecute.arn}"
}

resource "aws_iam_role_policy_attachment" "lambda_s3_execution_role_attachment_transcoder" {
  role = "${aws_iam_role.lambda_s3_execution_role.name}"
  policy_arn = "${data.aws_iam_policy.AmazonElasticTranscoderJobsSubmitter.arn}"
}

resource "aws_iam_role" "elastic_transcoder_role" {
  name = "elastic-transcoder-role"
  assume_role_policy = <<EOF
{
    "Version": "2008-10-17", 
    "Statement": [
        {
            "Action": "sts:AssumeRole", 
            "Principal": {
                "Service": "elastictranscoder.amazonaws.com"
            }, 
            "Effect": "Allow", 
            "Sid": "1"
        }
    ]
}
  EOF
}

resource "aws_iam_policy" "elastic_transcoder_policy" {
  name = "elastic-transcoder-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "1",
            "Effect": "Allow",
            "Action": [
                "s3:Put*",
                "s3:ListBucket",
                "s3:*MultipartUpload*",
                "s3:Get*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "2",
            "Effect": "Allow",
            "Action": "sns:Publish",
            "Resource": "*"
        },
        {
            "Sid": "3",
            "Effect": "Deny",
            "Action": [
                "s3:*Delete*",
                "s3:*Policy*",
                "sns:*Remove*",
                "sns:*Delete*",
                "sns:*Permission*"
            ],
            "Resource": "*"
        }
    ]
}
  EOF
}


resource "aws_iam_role_policy_attachment" "elastic_transcoder_role_policy" {
  role = "${aws_iam_role.elastic_transcoder_role.name}"
  policy_arn = "${aws_iam_policy.elastic_transcoder_policy.arn}"
}

output "lambda_upload user access key id" {
    value = "${aws_iam_access_key.lambda_upload_access.id}"
}

output "lambda_upload user access key secret" {
    value = "${aws_iam_access_key.lambda_upload_access.secret}"
}