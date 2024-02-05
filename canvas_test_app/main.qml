import QtQuick
import QtQuick.Controls
import QtQuick.Shapes

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: "QML Canvas Test"

	function addNewPolyline(){
		//var newPolyline = PathPolyline([Qt.point(myMouseArea.mouseX,myMouseArea.mouseY)]);
		var newPolyline = Qt.createQmlObject(`
			import QtQuick
			PathPolyline {
				path: [Qt.point(myMouseArea.mouseX,myMouseArea.mouseY)]
			}`,
			myfirstpath
		);

		//myfirstpath.addPathItem(newPolyline);

		return newPolyline;
	}


    Button {
    id: save_canvas
	width: 100
	height:30
	text: qsTr("Save canvas")
    }

    Rectangle {
	width: 640
	height: 450
	y: 30
    color: "lightblue"
	MouseArea {
		id: myMouseArea
		width: 640
		height: 450
		Shape {
			anchors.fill: parent
			ShapePath {
				id: myfirstpath
				strokeWidth: 3
				strokeColor: "darkgray"
				property PathPolyline currentPL
			}
		}
		onPressed: myfirstpath.currentPL= addNewPolyline(), console.log(myfirstpath.currentPL.path)
		onPositionChanged: {
			var newPath = myfirstpath.currentPL.path.slice()
			newPath.push(Qt.point(mouseX,mouseY));
			myfirstpath.currentPL.path = newPath;
			console.log(myfirstpath.currentPL.path);
		}
		//onReleased: myfirstpathline.x= mouseX,	myfirstpathline.y = mouseY, console.log("mouse up")


	}

	Image {
		id: bgImage
		source: "DSCN4472.jpg"
		visible: false
	}
	

    }
}

