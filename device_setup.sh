#!/bin/bash

# This will install the necessary packages to setup the device for realtime HLS Streaming

echo jetjet | sudo -S apt update 
echo jetjet | sudo -S apt install -y libssl-dev libcurl4-openssl-dev liblog4cplus-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev gstreamer1.0-plugins-base-apps gstreamer1.0-plugins-bad gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-tools

# DOwnloading the aws kinesis video streaming producer SDK 
git clone https://github.com/awslabs/amazon-kinesis-video-streams-producer-sdk-cpp.git

# Building the SDK
mkdir -p amazon-kinesis-video-streams-producer-sdk-cpp/build
cd amazon-kinesis-video-streams-producer-sdk-cpp/build
cmake .. -DBUILD_GSTREAMER_PLUGIN=ON -DBUILD_JNI=TRUE -DBUILD_DEPENDENCIES=OFF
make

# Exporting the variable 
# TODO: Make an entry into .bashrc 
echo 'export GST_PLUGIN_PATH=`pwd`/build'

