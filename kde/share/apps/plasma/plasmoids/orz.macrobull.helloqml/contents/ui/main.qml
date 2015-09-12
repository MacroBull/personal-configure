import QtQuick 1.1

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.graphicswidgets 0.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.graphicslayouts 4.7 as GraphicsLayouts

//import org.kde.kwin.decoration 0.1
//import org.kde.milou 0.1


Item {
	id: root
	visible: true
//	property int minimumWidth: width
//	property int minimumHeight: height


	onHeightChanged: {
		t.font.pointSize=height/20
	}


//	color: Qt.rgba(0, 0, 0, 0.2)

	MouseArea {
		anchors.fill: parent
		onClicked: {
			i.vx = Math.random()*2 - 1
			i.vy = Math.random()*2 - 1
		}
	}


	Text {
		id: t
		anchors.centerIn: parent
		text: i.x.toFixed().toString() + ',' + i.y.toFixed().toString()
		color: "white"
		opacity:  1 - i.opacity / 2
	}

	Timer {
		interval: 15
		running: true
		repeat: true
		onTriggered: {
			i.opacity = Math.abs(i.vx*i.vx + i.vy*i.vy)
			i.x += i.vx
			i.y += i.vy
			if ((i.x<=0)||((i.x+i.width>root.width)&&(i.vx >0))) i.vx = -i.vx + Math.random()*0.4 - 0.2;
			if ((i.y<=0)||((i.y+i.height>root.height)&&(i.vy >0))) i.vy = -i.vy + Math.random()*0.4 - 0.2;
			i.rotation = Math.atan2(i.vx, i.vy)

		}
	}

	Rectangle {
		id: i
		height: 64
		width: 64
		x: Math.random() * root.width
		y: Math.random() * root.height
		property real vx: Math.random()
		property real vy: Math.random()
		border.width: 5

		Image {
			source: "/home/macrobull/.face.icon"
			anchors.fill: parent
		}
	}
}

