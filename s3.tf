variable "s3_prefix" {
  default = "kjarm"
}

resource "aws_s3_bucket" "serverless_video_upload" {
    bucket = "${var.s3_prefix}-serverless-video-upload"
    acl = "private"
}

resource "aws_s3_bucket" "serverless_video_transcoded" {
    bucket = "${var.s3_prefix}-serverless-video-transcoded"
    acl = "private"
}
