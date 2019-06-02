resource "aws_elastictranscoder_pipeline" "24_hour_video" {
    name = "24-hour-video"
    input_bucket = "${aws_s3_bucket.serverless_video_upload.bucket}"
    role = "${aws_iam_role.elastic_transcoder_role.arn}"

    content_config {
        bucket = "${aws_s3_bucket.serverless_video_transcoded.bucket}"
        storage_class = "Standard"
    }

    thumbnail_config {
        bucket = "${aws_s3_bucket.serverless_video_transcoded.bucket}"
        storage_class = "Standard"
    }
}
