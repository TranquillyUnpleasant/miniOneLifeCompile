#!/bin/bash
set -e

# MacOS builds natively as platform 2, so default to it there
DEFAULT_PLATFORM=5
if [[ "$(uname -s)" = "Darwin" ]]; then DEFAULT_PLATFORM=2; fi

PLATFORM=$(cat PLATFORM_OVERRIDE)
if [[ $PLATFORM != 1 ]] && [[ $PLATFORM != 2 ]] && [[ $PLATFORM != 5 ]]; then PLATFORM=${1-$DEFAULT_PLATFORM}; fi
if [[ $PLATFORM != 1 ]] && [[ $PLATFORM != 2 ]] && [[ $PLATFORM != 5 ]]; then
	echo "Usage: 1 for Linux, 2 for MacOS, 5 for XCompiling for Windows"
	echo "Defaults to $DEFAULT_PLATFORM on this system"
	exit 1
fi
cd "$(dirname "${0}")/.."

##### Configure and Make
cd OneLife
./configure $PLATFORM

cd gameSource
if [[ $PLATFORM == 5 ]]; then export PATH="/usr/i686-w64-mingw32/bin:${PATH}"; fi
./makeEditor.sh

cd ../..


##### Create Game Folder
mkdir -p output
cd output

FOLDERS="animations categories ground music objects sounds sprites transitions"
TARGET="."
LINK="../OneLifeData7"
../miniOneLifeCompile/util/createSymLinks.sh $PLATFORM "$FOLDERS" $TARGET $LINK

FOLDERS="graphics otherSounds languages"
TARGET="."
LINK="../OneLife/gameSource"
../miniOneLifeCompile/util/createSymLinks.sh $PLATFORM "$FOLDERS" $TARGET $LINK

rsync -r --ignore-existing ../OneLife/gameSource/settings .
cp ../OneLife/gameSource/us_english_60.txt .

cp ../OneLife/gameSource/reverbImpulseResponse.aiff .

cp ../OneLifeData7/dataVersionNumber.txt .

#missing SDL.dll
if [[ $PLATFORM == 5 ]] && [ ! -f SDL.dll ]; then cp ../OneLife/build/win32/SDL.dll .; fi


##### Copy to Game Folder
if [[ $PLATFORM == 5 ]]; then cp -f ../OneLife/gameSource/EditOneLife.exe .; fi
if [[ $PLATFORM == 1 ]] || [[ $PLATFORM == 2 ]]; then 
cp -f ../OneLife/gameSource/EditOneLife .; 
cd ../output
./EditOneLife

fi






