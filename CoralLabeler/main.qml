import QtCore
import QtQuick 
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts 
import Qt.labs.folderlistmodel


//import QtGraphicalEffects 1.15
//import AppStyle 1.0



ApplicationWindow {
    width: 800
    height: 600
    visible: true

    function refreshMask() {
        overlay.source = "images/mask2.png"
        overlay.source = "images/mask.png"
    }

    //change main image function
    function changeImage(filename){
            image.source = filename;
            
    }

    

    ///
    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            Action { text: qsTr("&New...") }
            Action { text: qsTr("&Open...") }
            Action { text: qsTr("&Save") }
            Action { text: qsTr("Save &As...") }
            MenuSeparator { }
            Action { text: qsTr("&Quit") }
        }
        Menu {
            title: qsTr("&Edit")
            Action { text: qsTr("Cu&t") }
            Action { text: qsTr("&Copy") }
            Action { text: qsTr("&Paste") }
        }
        Menu {
            title: qsTr("&Help")
            Action { text: qsTr("&About") }
        }
        Menu {
            title: qsTr("&Tools")
            Action {
                text: qsTr("Random Rectangle")
                onTriggered: {
                    tbox.randomRectangle(), refreshMask()
                    saveIconButton.enabled = true
                }
            }
            Action {
                text: qsTr("Get AI Predictions")
                onTriggered: {
                    tbox.getPrediction(), refreshMask()
                    saveIconButton.enabled = true
                }
            }
        }
    }





    //row tool bar
    header: ToolBar {
        
        RowLayout {
            anchors.fill: parent
            
            ToolButton {
                text: qsTr("Choose Image")
    
                onClicked: fileDialog.open()
                Layout.alignment: Qt.AlignLeft

            }


            ToolButton {
                text: qsTr("Choose Folder")

                onClicked: {
                   folderDialog.open()
                }
                Layout.alignment: Qt.AlignLeft
            }
                   

            Button {

                id:saveIconButton
                Layout.preferredWidth: 50
                Layout.preferredHeight: 50
                enabled: false
                icon.source: "save.png"
                
                MouseArea {
                    anchors.fill: parent
                        
                    onClicked: {
                        enabled = false
                        console.info("image clicked!")
                    }
                    
                }
            }
            Slider {
                id: opacitySlider
                from: 0.0
                to: 1.0
                stepSize: .01
                value: .75
                onMoved: overlay.opacity = value
                visible: true
                height: 10
                width: 100
            }
    
         


            FileDialog {
                id: fileDialog
                currentFolder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
                onAccepted: image.source = selectedFile, tbox.initLabels(selectedFile), refreshMask()
            }


            StackView {
                id: stack
                anchors.fill: parent
            }


        }

   

    }

    //random rectangle for now to push image away from tool bar margin for image
    Rectangle{
        id: yuh
        width: parent.width/8
    }

    //file image
    Image {
        id: image
        anchors.left: yuh.right

        width: parent.height - parent.width/8
        height: parent.height - 50
    
        fillMode: Image.PreserveAspectFit

        Image {
            id: overlay
            anchors.fill: parent
            x: 0
            y: 0
            Layout.preferredWidth: 100
            Layout.preferredHeight: 100
            fillMode: Image.PreserveAspectFit
            smooth: true
            visible: true
            opacity: opacitySlider.value
            cache: false
        }
    }

    //////////
    ToolBar {
        ColumnLayout {
            id: toolbaryuh
                    
            width: parent.width/8
            anchors.fill: parent
                
            Image {

                id:magicWandIcon
                Layout.preferredWidth: 50
                Layout.preferredHeight: 50
                source: "magicwand.png"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.info("image clicked!")
                    }

                }
            }

            Image {
                id:paintbrushIcon
                Layout.preferredWidth: 50
                Layout.preferredHeight: 50
                source: "paintbrush.png"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.info("image clicked!")
                    }

                }
            }
            Image {
                id:circleSelectIcon
                Layout.preferredWidth: 50
                Layout.preferredHeight: 50
                source: "circleselect.png"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.info("image clicked!")
                    }

                }
            }
            Image {
                id:squareSelectIcon
                Layout.preferredWidth: 50
                Layout.preferredHeight: 50
                source: "squareselect.png"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.info("image clicked!")
                    }

                }
            }
       

        }
    }


    //Gallery stuff
    Rectangle{
        id:allGallery
        width: parent.width/8
        height: parent.height
        anchors.left: image.right

        visible: false


        //Places all images into a visible list
        ListView {
            id: gallery


            width: parent.width; height: parent.height

            //scrollable
            flickableDirection: Flickable.VerticalFlick

            //get contents of folder
            FolderListModel {
                id: folderModel

                folder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]

                nameFilters: ["*.jpg"]
            }

            //use these contents
            model: folderModel

            //create a component for every image
            Component {
                id: fileDelegate

                //make this image for every content
                Image{
                    source: folderModel.folder + "/" + fileName

                    width: gallery.width
                    height: width * (2/3)


                    //if another images is clicked that's not saved yet, prompt user to save
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (saveIconButton.enabled == true){
                                savemask.title = fileName
                                savemask.open()
                            }
                            else{
                                tbox.initLabels(folderModel.folder + "/" + fileName), refreshMask()
                                changeImage(folderModel.folder + "/" + fileName)
                            }
                            
                        }

                    }
                }
            }

            //Make all components from folder
            delegate: fileDelegate
        }
    }



    //choose a filder dialog
    FolderDialog {
        id: folderDialog

        onAccepted: {
            folderModel.folder = selectedFolder
            allGallery.visible = true
        }
    }

    
    //save dialog
    Dialog{
        id: savemask

        title: "Would you like to save?"

        width: 400
        height: 200

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        standardButtons: Dialog.Save|Dialog.No


        Text{
            text: "Would you like to save your mask before changing images?"

        }

        onAccepted: {
            console.log("save when we know how to save")
            saveIconButton.enabled = false
            changeImage(folderModel.folder + "/" + savemask.title)
            tbox.initLabels(folderModel.folder + "/" + savemask.title), refreshMask()
        }

        onRejected: {
            changeImage(folderModel.folder + "/" + savemask.title)
            tbox.initLabels(folderModel.folder + "/" + savemask.title), refreshMask()
        }
    }


}

