# Script is usless now, as of iOS 9.3 support for AC3 is included and 5.1 plays back fine on mobile (just in two channel)

# mkv2m4v

This is just a stupid bash script to remux an mkv containing either DTS or AC3 audio streams and put them in a compatible format for iOS devices 
using ffmpeg.

# Requirements

* Linux
* ffmpeg compiled with libfdk_aac
* ffprobe
* QT Faststart

# What it will do
* Copy h264
* Encode DTS to AC3 or copy AC3 if detected (except 2 channel AC3, that will simply be encoded to AAC)
* Set AC3 stream to disable since the Apple TV will playback both streams marked (default)
* Encode 2 Channel AAC from first audio stream
* Relocate moov 

# What it will not do
* Tag a file with metadata and artwork (check out https://github.com/mdhiggins/sickbeard_mp4_automator for that)

# Usage
mkv2m4v.sh (input directory/file) (output directory)
