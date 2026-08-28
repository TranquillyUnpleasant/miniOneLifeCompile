#!/bin/bash
set -e
AUTORUN=$(cat AUTORUN)

# MacOS builds natively as platform 2, so default to it there
DEFAULT_PLATFORM=1
if [[ "$(uname -s)" = "Darwin" ]]; then DEFAULT_PLATFORM=2; fi

PLATFORM=$(cat PLATFORM_OVERRIDE)
if [[ $PLATFORM != 1 ]] && [[ $PLATFORM != 2 ]] && [[ $PLATFORM != 5 ]]; then PLATFORM=${1-$DEFAULT_PLATFORM}; fi
if [[ $PLATFORM != 1 ]] && [[ $PLATFORM != 2 ]] && [[ $PLATFORM != 5 ]]; then
	echo "Usage: 1 for Linux, 2 for MacOS, 5 for XCompiling for Windows"
	echo "Defaults to $DEFAULT_PLATFORM on this system"
	exit 1
fi
pushd .
cd "$(dirname "${0}")/.."


##### Configure and Make
cd OneLife/server
./configure $PLATFORM

make

cd ../..


##### Create Game Folder
mkdir -p output
cd output

FOLDERS="objects transitions categories tutorialMaps"
TARGET="."
LINK="../OneLifeData7"
../miniOneLifeCompile/util/createSymLinks.sh $PLATFORM "$FOLDERS" $TARGET $LINK


rsync -r --ignore-existing ../OneLife/server/settings .

cp ../OneLife/server/firstNames.txt .
cp ../OneLife/server/lastNames.txt .
cp ../OneLife/server/wordList.txt .

cp ../OneLifeData7/dataVersionNumber.txt .


##### Copy to Game Folder and Run
if [[ $PLATFORM == 5 ]]; then mv ../OneLife/server/OneLifeServer.exe .; fi
if [[ $PLATFORM == 1 ]] || [[ $PLATFORM == 2 ]]; then mv ../OneLife/server/OneLifeServer .; fi

popd
if [[ $AUTORUN == 1 ]]; then ./runServer.sh; fi