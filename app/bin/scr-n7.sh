SCR_NAME=Nexus7
SCR_WID=800
SCR_HEI=1024
FPS=60
CVT_RES=`cvt $SCR_WID $SCR_HEI $FPS`
CVT_RES=${CVT_RES##*\"}
CLIPRECT=${SCR_WID}x${SCR_HEI}+0+0
echo $CLIPRECT

xrandr | grep $SCR_NAME  || ( xrandr --newmode $SCR_NAME $CVT_RES && xrandr --addmode VIRTUAL1 $SCR_NAME && xrandr --dpi 96 --output VIRTUAL1 --mode $SCR_NAME --left-of LVDS1 )
x11vnc -rfbport 5900 --clip $CLIPRECT
