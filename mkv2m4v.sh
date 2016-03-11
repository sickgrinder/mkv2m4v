#!/bin/bash
in=$1
out=$2


IFS=$'\n'
for i in $(find "$in" -name *.mkv); do
    
#A shitty way to determine if a file has DTS audio or just 6 channel AC3, i'm sure there is a better way but this works.

chan=$(ffprobe "$i" -show_streams 2>/dev/null | grep -i "channels" | cut -d= -f2)
profile=$(ffprobe "$i" -show_streams 2>/dev/null | grep -i "codec_name=dca" | cut -d= -f2)
profile2=$(ffprobe "$i" -show_streams 2>/dev/null | grep -i "codec_name=aac" | cut -d= -f2)
codec='dca'
codec2='aac'

#For DTS to AC3 conversion.

if [[ "$profile" ==  "$codec" ]]; then 

ffmpeg -i "$i" -map 0:1 -vn -c:a ac3 -ac:a 6 -b:a 384k "$out"/out.ac3 && ffmpeg -i "$i" -map 0:1 -vn -c:a libfdk_aac -b:a 160k -ac:a 2 "$out"/out.m4a && ffmpeg -i "$i" -map 0:0 -c:v copy "$out"/out.mp4
ffmpeg -i "$out"/out.mp4 -i "$out"/out.m4a -i "$out"/out.ac3 -map 0:0 -map 1:0 -map 2:0 -metadata:s:a:0 handler="Stereo" -metadata:s:a:1 handler="Dolby Surround" -metadata:s:a:0 language=eng -metadata:s:a:1 language=eng -c:v copy -c:a:0 copy -c:a:1 copy -movflags faststart -threads 0 "$out"/$(basename "${i/.mkv}").m4v

rm -rf "$out"/out.*

#For AC3 stream copy.

elif [[ "$chan" == 6 ]]; then

ffmpeg -i "$i" -map 0:a -vn -c:a copy "$out"/out.ac3 && ffmpeg -i "$i" -map 0:a -vn -c:a libfdk_aac -b:a 160k -ac:a 2 "$out"/out.m4a && ffmpeg -i "$i" -map 0:v -c:v copy "$out"/out.mp4

ffmpeg -i "$out"/out.mp4 -i "$out"/out.m4a -i "$out"/out.ac3 -map 0:0 -map 1:0 -map 2:0  -metadata:s:a:0 handler="Stereo" -metadata:s:a:1 handler="Dolby Surround" -metadata:s:a:0 language=eng -metadata:s:a:1 language=eng -c:v copy  -c:a:0 copy -c:a:1 copy -movflags faststart -threads 0 "$out"/$(basename "${i/.mkv}").m4v

rm -rf "$out"/out.*

#For two channel aac streams, mostly found in standard definition 

elif [[ "$profile2" == "$codec2" ]]; then

ffmpeg -i "$i" -map 0:v -c:v copy -metadata:s:a:0 handler="Stereo" -map 0:a -c:a copy -movflags faststart -threads 0 "$out"/$(basename "${i/.mkv}").m4v

#This is for videos that only contain two channel AC3.

else
 
ffmpeg -i "$i" -map 0:v -c:v copy -metadata:s:a:0 handler="Stereo" -map 0:a -c:a libfdk_aac -b:a 160k -movflags faststart -threads 0 "$out"/$(basename "${i/.mkv}").m4v

fi


done