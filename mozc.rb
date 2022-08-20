require "formula"

class Googlejapaneseinput < Formula
  homepage "https://github.com/cafenero/homebrew-mozc"
  url "https://github.com/cafenero/homebrew-mozc"
  version "0.0.1"

  depends_on "ninja"
  depends_on "python3"

  def install
    os_version = `sw_vers | grep ProductVersion | awk '{print $2}'`
    sdk_version=`xcrun -sdk macosx --show-sdk-version`


    # debug
    # system "cp -r $HOME/mozc ."
    system "git clone https://github.com/google/mozc.git -b master --single-branch --recursive"


    Dir.chdir "mozc" do
      # commit id: ea60ef4b651be0b02df4a709ad863a51b9e1ba41 latest at 2022/08/19
      system "git checkout ea60ef4b651be0b02df4a709ad863a51b9e1ba41"


      # debug
      # system 'cp ~/mozc-emacs-helper.patch .'
      system 'curl -O https://raw.githubusercontent.com/cafenero/homebrew-mozc-emacs-helper/master/mozc-emacs-helper.patch'
      system "patch -p1 < mozc-emacs-helper.patch"

      Dir.chdir "src" do
        system "cd third_party/gyp; git apply ../../gyp/gyp.patch; cd ../../"

        os_version = `sw_vers | grep ProductVersion | awk '{print $2}'`
        sdk_version=`xcrun -sdk macosx --show-sdk-version`
        system "GYP_DEFINES='mac_sdk=#{sdk_version} mac_deployment_target=#{os_version}' python3 build_mozc.py gyp --noqt"
        system 'export PATH=/opt/homebrew/bin:$PATH; python3 build_mozc.py build -c Release mac/mac.gyp:GoogleJapaneseInput'



        ## FIX HERE
        ## ----------------

        # bin.install 'out_mac/Release/mozc_emacs_helper'
        system 'cp mac/installer/LaunchAgents/org.mozc.inputmethod.Japanese.Converter.plist /Library/LaunchAgents'
        system 'cp mac/installer/LaunchAgents/org.mozc.inputmethod.Japanese.Renderer.plist /Library/LaunchAgents'
        system 'cp -r out_mac/Release/Mozc.app /Library/Input\ Methods/'

        # $ sudo cp mac/installer/LaunchAgents/org.mozc.inputmethod.Japanese.Converter.plist /Library/LaunchAgents
        # $ sudo cp mac/installer/LaunchAgents/org.mozc.inputmethod.Japanese.Renderer.plist /Library/LaunchAgents
        # $ sudo cp -r out_mac/Release/Mozc.app /Library/Input\ Methods/
        ## ----------------

      end
    end
  end
end
