# ALCPlugFix-Swift

(c) 2020 black.dragon74 aka Nick

macOS daemon to send HD Audio commands (HDA Verbs) to an `IOHDACodecDevice` from user-sapce.

## Features
- Codeless configuration using a custom `PLIST` file
- Supports sending verbs on system boot/sleep/wake, headset plug/unplug and audio mute/unmute optionally
- Doesn't require `CodecCommander`, `hda-verb` or `alc-verb` to function

Note: Requires AppleALC version 1.5.4+ or the patch of commit [61e2bbf](https://github.com/acidanthera/AppleALC/commit/61e2bbfe74bf1c12ebf770ed4a9776a04a7758f2) applied.

## Installing

Download the appropriate version from the [Releases](https://github.com/black-dragon74/ALCPlugFix-Swift/releases/) and extract the zip file.

Now open the `Terminal.app` and follow the instructions.
```sh
# CD to the downloded directory
cd your_directory_here

# Run the install.sh
./install.sh
```

## Building

### From GitHub:

Install Xcode, clone the GitHub repo and enter the top-level directory.  Then:

```sh
xcodebuild -configuration Release
```

## Credits

- [goodwin](https://github.com/goodwin) for original work on Obj-C based ALCPlugFix
- [zen-zhen](https://github.com/zhen-zen) for direct kernelspace connection
- [black-dragon74](https://github.com/black-dragon74) for writing and maintaing this software

