 #!/bin/sh

echo "------RCWhiteBoard build start ----------------"
RCWhiteBoard_FRAMEWORKER_PATH="./framework"
if [ ! -d "$RCWhiteBoard_FRAMEWORKER_PATH" ]; then
    mkdir -p "$RCWhiteBoard_FRAMEWORKER_PATH"
fi

#copy imlib
WB_SDK_PATH="../RCWhiteBoard/bin"
if [ -d "$WB_SDK_PATH" ]; then
    cp -af ${WB_SDK_PATH}/* $RCWhiteBoard_FRAMEWORKER_PATH
fi
