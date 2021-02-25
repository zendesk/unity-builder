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

# The build specification below may require Unity 2019.2.11f1 or later (not tested below).
# Reference: https://docs.unity3d.com/2019.3/Documentation/Manual/CommandLineArguments.html

#
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
echo "##################################"
echo "#    Generating unity project    #"
echo "##################################"
echo ""

unity-editor \
  -nographics \
  -logfile /dev/stdout \
  -quit \
  -createProject "$UNITY_PROJECT_PATH"


echo ""
echo "###########################"
echo "#    Importing Package    #"
echo "###########################"
echo ""

unity-editor \
  -nographics \
  -projectPath "$UNITY_PROJECT_PATH"\
  -logfile /dev/stdout \
  -quit \
  -importPackage "$PACKAGE_PATH"

# Catch exit code
BUILD_EXIT_CODE=$?

# Display results
if [ $BUILD_EXIT_CODE -eq 0 ]; then
  echo "Build succeeded";
else
  echo "Build failed, with exit code $BUILD_EXIT_CODE";
fi

#
# Results
#

echo ""
echo "###########################"
echo "#     Build directory     #"
echo "###########################"
echo ""

ls -alh "$BUILD_PATH_FULL"

echo ""
echo "###########################"
echo "#     Project Files       #"
echo "###########################"
echo ""

ls -alh "$BUILD_PATH_FULL"