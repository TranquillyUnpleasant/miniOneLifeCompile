#!/bin/bash
set -e

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
cd "$(dirname "${0}")/.."

cd output
if [[ $PLATFORM == 5 ]]; then cmd.exe /c  OneLifeServer.exe; fi
if [[ $PLATFORM == 1 ]] || [[ $PLATFORM == 2 ]]; then ./OneLifeServer; fi