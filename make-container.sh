#!/bin/bash
set -e
set -x
./make-dchrt-ng.sh
# Split out these so this can be called from make-both.sh
./make-container-post.sh

