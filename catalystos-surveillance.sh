#!/bin/bash

aws_kinesis_stream_name="test_catalyst"
aws_region=us-east-1
aws_access_key=AKIAILNCYLCL3ZRDJX7Q
aws_secret_key=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

gst-launch-1.0 nvarguscamerasrc ! 'video/x-raw(memory:NVMM), format=NV12, width=640, height=480' ! nvv4l2h264enc insert-sps-pps=true ! h264parse ! kvssink stream-name="${aws_kinesis_stream_name}" access-key="${aws_access_key}" secret-key="${aws_sercret_key}" aws-region="${aws_region}"
