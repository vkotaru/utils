
### ffmpeg usage:

- To reduce video size [(source)](https://unix.stackexchange.com/questions/28803/how-can-i-reduce-a-videos-size-with-ffmpeg)
   ```
    ffmpeg -i input.mp4 -vcodec libx265 -crf 28 output.mp4
    ```
- To crop a video [(source)](https://video.stackexchange.com/questions/4563/how-can-i-crop-a-video-with-ffmpeg)
    ```
    ffmpeg -i in.mp4 -filter:v "crop=out_w:out_h:x:y" out.mp4
    ```
- To trim a video 
    ```
    ffmpeg -i out.mp4 -ss 00:00:45.00 -to 00:02:05 -c copy trimmer_log3.mp4
    ```