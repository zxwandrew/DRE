import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1

import ArcGIS.Runtime 10.26
//import ArcGIS.AppFramework 1.0
//import ArcGIS.AppFramework.Controls 1.0
//import ArcGIS.AppFramework.Runtime 1.0


Rectangle {
    id: welcomeContainer
    width: parent.width
    height: parent.height


    signal next(string message)

    function callNext(){
        next("newSelector")
    }
    function updateWelcomeStatus(status){
        welcomeStatus.text = status
    }

    function updateWelcomeBusyIndicator(busy){
        welcomeBusy = busy
    }

    Component.onCompleted: {
        serviceInfoTask.fetchFeatureServiceInfo();
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 5 * app.scaleFactor

        Text {
            id: appName
            text: qsTr("Disconnected \nRelationship \nEditor")
            fontSizeMode: Text.HorizontalFit
            font.pointSize: baseFontSize* titleFontScale
            font.bold: true
            font.family: "Tahoma"
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
        }

        CustomButton{
            id: welcomeInit
            buttonText: "Initialize \n Disconnected Environment"
            //buttonFill: AppFramework.network.isOnline
            buttonWidth: 300 * app.scaleFactor
            buttonHeight: buttonWidth/5
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                bottomMargin: 150*app.scaleFactor
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    //DL and prep for local .geodatabase\
                    if(!gdb.valid){
                        console.log(gdbPath)
                        console.log(gdb.path)
                        generateGeodatabaseParameters.initialize(serviceInfoTask.featureServiceInfo)
                        generateGeodatabaseParameters.extent = initialExtent
                        generateGeodatabaseParameters.returnAttachments = false
                        generateGeodatabaseParameters.layerIds = [0,1,2]
                        console.log(generateGeodatabaseParameters.extent.spatialReference.latestWkid)
                        geodatabaseSyncTask.generateGeodatabase(generateGeodatabaseParameters,gdbPath)
                    }else{
                        console.log("Exists")
                        next("newSelector")
                    }
                }
            }
        }

        BusyIndicator {
            id: welcomeBusyIndicator
            running: welcomeBusy
            anchors.centerIn: parent
        }

        Text{
            id: welcomeStatus
            text: qsTr(" ")
            width: 300 * app.scaleFactor
            fontSizeMode: Text.HorizontalFit
            font.pointSize: baseFontSize
            font.family: "Tahoma"
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
        }
    }
}

