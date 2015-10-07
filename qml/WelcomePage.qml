import QtQuick 2.0

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import ArcGIS.AppFramework.Runtime 1.0


Rectangle {
    id: welcomeContainer
    width: parent.width
    height: parent.height

    signal next(string message)

    Component.onCompleted: {
        serviceInfoTask.fetchFeatureServiceInfo();
    }

    Rectangle {
        id: rectangle1
        x: 0
        y: 0
        width: 400
        height: 639
        color: "#ffffff"

        Text {
            id: text1
            x: 194
            text: qsTr("Disconnected \nRelationship \nEditor")
            style: Text.Normal
            font.bold: true
            font.family: "Tahoma"
            horizontalAlignment: Text.AlignHCenter
            anchors.top: parent.top
            anchors.topMargin: 100
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 30
        }

        CustomButton{
            id:page1_button1
            buttonText: "Initialize \n Disconnected Environment"
            buttonFill: AppFramework.network.isOnline
            buttonWidth: 300 * app.scaleFactor
            buttonHeight: buttonWidth/5
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                bottomMargin: 40*app.scaleFactor
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    //DL and prep for local .geodatabase\
                    if(!gdb.path){
                        generateGeodatabaseParameters.initialize(serviceInfoTask.featureServiceInfo)
                        generateGeodatabaseParameters.extent = initialExtent
                        generateGeodatabaseParameters.returnAttachments = false;
                        console.log(generateGeodatabaseParameters.extent.spatialReference.latestWkid)
                        geodatabaseSyncTask.generateGeodatabase(generateGeodatabaseParameters,gdbPath);
                    }else{
                        console.log("Exists")
                        next("newSelector")
                    }
                }
            }
        }
    }
}

