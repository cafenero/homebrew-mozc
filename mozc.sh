#!/bin/bash -xe

sudo pwd

# depends_on "ninja"
# depends_on "python3"

# debug
# cp -r ~/mozc .
git clone https://github.com/google/mozc.git -b master --single-branch --recursive


cd mozc
# ea60ef4b651be0b02df4a709ad863a51b9e1ba41 : latest at 2022/08/19
git checkout ea60ef4b651be0b02df4a709ad863a51b9e1ba41


curl -O https://raw.githubusercontent.com/cafenero/homebrew-mozc-emacs-helper/master/mozc-emacs-helper.patch
patch -p1 < mozc-emacs-helper.patch

cd src

cd third_party/gyp;
git apply ../../gyp/gyp.patch;
cd ../../


## build
os_version=`sw_vers | grep ProductVersion | awk '{print $2}'`
sdk_version=`xcrun -sdk macosx --show-sdk-version`
GYP_DEFINES="mac_sdk=${sdk_version} mac_deployment_target=${os_version}" python3 build_mozc.py gyp --noqt
export PATH=/opt/homebrew/bin:$PATH; python3 build_mozc.py build -c Release mac/mac.gyp:GoogleJapaneseInput


## install
sudo cp -r out_mac/Release/Mozc.app /Library/Input\ Methods/
sudo cp mac/installer/LaunchAgents/org.mozc.inputmethod.Japanese.Converter.plist /Library/LaunchAgents
sudo cp mac/installer/LaunchAgents/org.mozc.inputmethod.Japanese.Renderer.plist /Library/LaunchAgents

echo "YOU NEED reboot MacOS to use Mozc (Google Japanese Input) and Mozc-emacs-heler !!!"
echo "YOU NEED reboot MacOS to use Mozc (Google Japanese Input) and Mozc-emacs-heler !!!"
echo "YOU NEED reboot MacOS to use Mozc (Google Japanese Input) and Mozc-emacs-heler !!!"
