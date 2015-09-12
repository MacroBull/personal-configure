SCR_NAME=Nexus7
SCR_WID=1200
SCR_HEI=750
FPS=60
CVT_RES=`cvt $SCR_WID $SCR_HEI $FPS`
CVT_RES=${CVT_RES##*\"}
CLIPRECT=${SCR_WID}x${SCR_HEI}+0+768
echo $CLIPRECT

xrandr | grep $SCR_NAME  || ( xrandr --newmode $SCR_NAME $CVT_RES && xrandr --addmode VIRTUAL1 $SCR_NAME && xrandr --output VIRTUAL1 --mode $SCR_NAME below LVDS1 )
x11vnc -rfbport 5900 --clip $CLIPRECT
