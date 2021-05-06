#!/usr/bin/env bash

#
# Set project path
#

UNITY_PROJECT_PATH="$GITHUB_WORKSPACE/$PROJECT_PATH"
echo "Using project path \"$UNITY_PROJECT_PATH\"."

#
# Display the name for the build, doubles as the output name
#

echo "Using build name \"$BUILD_NAME\"."

#
# Display the build's target platform;
#

echo "Using build target \"$BUILD_TARGET\"."

#
# Display build path and file
#

echo "Using build path \"$BUILD_PATH\" to save file \"$BUILD_FILE\"."
BUILD_PATH_FULL="$GITHUB_WORKSPACE/$BUILD_PATH"
CUSTOM_BUILD_PATH="$BUILD_PATH_FULL/$BUILD_FILE"

#
# Display custom parameters
#
echo "Using custom parameters $CUSTOM_PARAMETERS."

# Build info
#

echo ""
echo "###########################"
echo "#    Current build dir    #"
echo "###########################"
echo ""

echo "Creating \"$BUILD_PATH_FULL\" if it does not exist."
mkdir -p "$BUILD_PATH_FULL"
ls -alh "$BUILD_PATH_FULL"

echo ""
echo "###########################"
echo "#    Project directory    #"
echo "###########################"
echo ""

ls -alh $UNITY_PROJECT_PATH

echo ""
echo "####################################"
echo "#    Generating unity project      #"
echo "# Project Path: $UNITY_PROJECT_PATH#"
echo "####################################"
echo ""

xvfb-run --auto-servernum --server-args='-screen 0 640x480x24' \
  /opt/Unity/Editor/Unity \
    -batchmode \
    -nographics \
    -logfile /dev/stdout \
    -quit \
    -createProject "$UNITY_PROJECT_PATH"

echo ""
echo "########################################"
echo "#    Importing Packages                #"
echo "#    Package List: $PACKAGE_PATH       #"
echo "########################################" 
echo ""

for package in $(echo $PACKAGE_PATH | sed "s/,/ /g")
do
echo ""
echo "###################################"
echo "#    Importing Package            #"
echo "#    Package: $package            #"
echo "###################################" 
echo ""

fullPackagePath="$GITHUB_WORKSPACE/$package"
echo "Full Package Path: $fullPackagePath"

xvfb-run --auto-servernum --server-args='-screen 0 640x480x24' \
  /opt/Unity/Editor/Unity \
    -batchmode \
    -nographics \
    -projectPath "$UNITY_PROJECT_PATH"\
    -logfile /dev/stdout \
    -quit \
    -importPackage "$fullPackagePath"

# Catch exit code
BUILD_EXIT_CODE=$?

# Display results
if [ $BUILD_EXIT_CODE -eq 0 ]; then
  echo "Build succeeded";
else
  echo "Build failed, with exit code $BUILD_EXIT_CODE";
fi

done

echo ""
echo "###########################"
echo "#     Build directory     #"
echo "###########################"
echo ""

ls -alh "$BUILD_PATH_FULL"
ls -alh "$UNITY_PROJECT_PATH"
ls -alh "$UNITY_PROJECT_PATH/Assets"
ls -alh "$UNITY_PROJECT_PATH/Assets/Zendesk"


echo ""
echo "######################################"
echo "#     Validate extracted package     #"
echo "######################################"
echo ""

for entry in "$UNITY_PROJECT_PATH/Assets/Zendesk"/*
do
  echo "$entry"
done
