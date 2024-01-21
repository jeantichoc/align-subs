#!/bin/bash

for srt_file in "$@" ; do
    # Check if the file is an srt file
    if [[ "$srt_file" != *.srt ]] ; then
        echo "$srt_file is not an srt file"
        continue
    fi

    filename=$(basename -- "$srt_file")
    lang=$(echo $filename | sed "s/.*\.\([A-z][A-z]\)\.srt$/\1/")
    filename_without_lang=$(echo "$filename" | sed 's/\(\.[A-z][A-z]\)\{0,1\}\.srt//')

    # Find the video file that matches the filename
    video_file=$(find . -type f \( -iname "*$filename_without_lang*.mp4" -or -iname "*$filename_without_lang*.avi" -or -iname "*$filename_without_lang*.mkv" \) | sort | head -n 1)
    if [ -z "$video_file" ] ; then
        echo "No video file found for $filename_without_lang"
        continue
    fi

    if [[ $lang ]] ; then
        new_srt=${video_file%.*}.${lang}.srt
    else
        new_srt=${video_file%.*}.srt
    fi


    # Execute the command ffs video.mp4 -i subtitle.srt -o new_subtitle.srt
    ffs "$video_file" -i "$srt_file" -o "${srt_file%.*}.new.srt"

    # If the execution returns an error, log that there was an error and continue
    if [ $? -ne 0 ] ; then
        echo "Error executing ffs for $srt_file"
        continue
    fi

    # If the output video doesn't exist after the execution, log that there was an issue, then continue
    if [ ! -f "${srt_file%.*}.new.srt" ] ; then
        echo "Output file not found for $srt_file"
        continue
    fi

    # Swap the new subtitles file with the original subtitles, keep the original subtitles with a suffix .backup
    mv "$srt_file" "${srt_file%.*}.backup.srt"
    mv "${srt_file%.*}.new.srt" "${new_srt}"
done
