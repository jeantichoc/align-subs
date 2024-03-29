# align-subs
bash script to align and rename subtitles using [FFsubsync](https://github.com/smacke/ffsubsync)

[FFsubsync](https://github.com/smacke/ffsubsync) is an awesome language-agnostic automatic synchronization of subtitles with video, so that
subtitles are aligned to the correct starting point within the video.

Turn this:                       |  Into this:
:-------------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/smacke/ffsubsync/master/resources/img/tearing-me-apart-wrong.gif)  |  ![](https://raw.githubusercontent.com/smacke/ffsubsync/master/resources/img/tearing-me-apart-correct.gif)


Visit https://github.com/smacke/ffsubsync to install it before using align-subs


## Usage

```
./align-subs.sh [srt_file ...]
```

## Example

```
.
├── S01E01.The.Begin.mp4
├── S01E01.en.srt
├── S01E02.The.Middle.avi
├── S01E02.The.Middle.en.srt
├── S01E02.fr.srt
├── S01E03.The.End.mkv
└── S01E03.The.End.srt

./align-subs.sh *.srt

.
├── S01E01.The.Begin.mp4
├── S01E01.The.Begin.en.srt
├── S01E01.en.srt.backup
├── S01E02.The.Middle.avi
├── S01E02.The.Middle.en.srt
├── S01E02.The.Middle.fr.srt
├── S01E02.The.Middle.en.srt.backup
├── S01E02.fr.srt.backup
├── S01E03.The.End.mkv
└── S01E03.The.End.srt
└── S01E03.The.End.srt.backup
```


This will align all the subtitles in the current directory with their matching video files.

The script will iterate through all srt files passed as arguments, find the video file that matches the filename, and execute the command `ffs video.mp4 -i subtitle.srt -o new_subtitle.srt`. If the execution returns an error, it logs that there was an error and continues the loop. If the output video doesn't exist after the execution, it logs that there was an issue and continues the loop. Finally, it swaps the new subtitles file with the original subtitles, rename it as an exact match of the video, keeping the original subtitles with a suffix `.backup`.

Please note that the script assumes that the video files have the extensions `mp4`, `avi`, or `mkv`.
