#!/bin/bash
export SDKROOT=$(xcrun --show-sdk-path)
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LIBRARY_PATH=/usr/local/lib
bundle exec jekyll serve