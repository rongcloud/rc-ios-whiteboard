#!/bin/sh

trap exit ERR

CONFIGURATION="Release"
BIN_DIR="bin"
BUILD_DIR="rcbuild"
export Need_Extract_Arch="true"

CUR_PATH=$(pwd)

sh before_build.sh

for((options_index = 1; options_index < $#; options_index=$[$options_index+2])) do
params_index=$[$options_index+1]
PFLAG=`echo $@|cut -d ' ' -f ${options_index}`
PPARAM=`echo $@|cut -d ' ' -f ${params_index}`
if [[ $PPARAM =~ ^- ]]; then
    PPARAM=""
    options_index=$[$options_index-1]
fi
if [ $PFLAG == "-version" ]
then
VER_FLAG=$PPARAM
elif [ $PFLAG == "-wbserver" ]
then
WB_SERVER=$PPARAM
elif [ $PFLAG == "-appkey" ]
then
DEMO_APPKEY=$PPARAM
fi
done

# 更新 pod
pod update --no-repo-update
echo "APP_NAME"
echo ${APP_NAME}

#appkey
echo $DEMO_APPKEY
if [ -n "${DEMO_APPKEY}" ]; then
    sed -i '' -e '/RCWBAPPKEY/s/@"pgyu6atqp2p9u"/@"'$DEMO_APPKEY'"/g' ./RCWhiteBoardDemo/Util/RCWBCommonDefine.h
fi

#wbserver
echo $WB_SERVER
if [ -n "${WB_SERVER}" ]; then
    sed -i '' -e 's?https://whiteboard-app-server.ronghub.com?'$WB_SERVER'?g' ./RCWhiteBoardDemo/Util/HTTP/HTTPUtility.m
fi

#version
echo $VER_FLAG
Bundle_Short_Version=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" ./RCWhiteBoardDemo/Info.plist)
sed -i "" -e '/CFBundleShortVersionString/{n;s/'"${Bundle_Short_Version}"'/'"$VER_FLAG"\ "$RELEASE_FLAG"'/; }' ./RCWhiteBoardDemo/Info.plist


BUILD_APP_PROFILE=""
BUILD_SHARE_PROFILE=""

BUILD_CODE_SIGN_IDENTITY="iPhone Distribution: Beijing Rong Cloud Network Technology CO., LTD"

echo $VER_FLAG

PROJECT_NAME="RCWhiteBoardDemo.xcodeproj"
targetName="RCWhiteBoardDemo"
TARGET_DECIVE="iphoneos"

rm -rf DerivedData
rm -rf "$BIN_DIR"
rm -rf "$BUILD_DIR"
mkdir -p "$BIN_DIR"
mkdir -p "$BUILD_DIR"
xcodebuild clean -alltargets

echo "***开始build iphoneos文件***"
  xcodebuild -scheme "${targetName}" archive -archivePath "./${BUILD_DIR}/${targetName}.xcarchive" -configuration "Release" APP_PROFILE="${BUILD_APP_PROFILE}" SHARE_PROFILE="${BUILD_SHARE_PROFILE}"
  xcodebuild -exportArchive -allowProvisioningUpdates -archivePath "./${BUILD_DIR}/${targetName}.xcarchive" -exportOptionsPlist "archive.plist" -exportPath "./${BIN_DIR}"
  
#    mv ./${BIN_DIR}/${targetName}.ipa ${CUR_PATH}/${BIN_DIR}/${APP_NAME}_v${VER_FLAG}_${CONFIGURATION}_${CUR_TIME}.ipa
#    cp -af ./${BUILD_DIR}/${targetName}.xcarchive/dSYMs/${targetName}.app.dSYM ${CUR_PATH}/${BIN_DIR}/${APP_NAME}_v${VER_FLAG}_${CONFIGURATION}_${CUR_TIME}.app.dSYM
  
echo "***编译结束***"
