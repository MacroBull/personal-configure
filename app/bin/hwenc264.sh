mkfifo channel
ffmpeg -i s.mp4 -f rawvideo -
h264encode -w 1920 -h 1080 -o d.h264 -f 30 --minqp 22 --srcyuv t.yuv --profile HP --fourcc IYUV
h264encode -w 1920 -h 1080 -o d.h264 -f 30 --minqp 22 --profile HP --fourcc IYUV --srcyuv < channel



fourcc IYUV --srcyuv t.yuv -o d.1
 1311* ffmpeg -i s.mp4 -t 6 -f rawvideo -y t.yuv -ss 6
 1312  h264encode -w 1920 -h 1080 -n 0 -f 30 --minqp 22 --profile HP --fourcc IYUV --srcyuv t.yuv -o d.2
 1313  mpv d.1
 1314  mpv d.2
 1315* ffmpeg -i s.mp4 -t 6 -ss 6 -f rawvideo -y t.yuv
 1316  mpv d.2
 1317  ffmpeg -i s.mp4 -t 6 -ss 6 -f rawvideo -y t.yuv
 1318  mpv d.2
 1319* ffmpeg -t 6 -ss 6 -i s.mp4 -f rawvideo -y t.yuv
 1320  ffmpeg -i s.mp4 -t 6 -ss 6 -f rawvideo -y t.yuv
 1321  h264encode -w 1920 -h 1080 -n 0 -f 30 --minqp 22 --profile HP --fourcc IYUV --srcyuv t.yuv -o d.2
 1322* ffmpeg -t 6 -ss 6 -i s.mp4 -f rawvideo -y t.yuv
 1323  h264encode -w 1920 -h 1080 -n 0 -f 30 --minqp 22 --profile HP --fourcc IYUV --srcyuv t.yuv -o d.2
 1324  mpv d.2
 1325  rm dst.h264
 1326  touch d.h264
 1327  cat d.1 >> d.h264
 1328  cat d.2 >> d.h264
 1329  mpv d.h264
 1330  h264encode -w 2560 -h 1920 -n 0 -f 30 --minqp 22 --profile HP --fourcc IYUV --srcyuv t.yuv -o d.2
