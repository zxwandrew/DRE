
// Copyright 2015 ESRI
//
// All rights reserved under the copyright laws of the United States
// and applicable international laws, treaties, and conventions.
//
// You may freely redistribute and use this sample code, with or
// without modification, provided you include the original copyright
// notice and use restrictions.
//
// See the Sample code usage restrictions document for further information.
//

//import QtQuick 2.3
//import QtQuick.Controls 1.2
import ArcGIS.Runtime 10.26

import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1

//import ArcGIS.AppFramework 1.0
//import ArcGIS.AppFramework.Controls 1.0
//import ArcGIS.AppFramework.Runtime 1.0



ApplicationWindow {
    id: app
    width: 400
    height: 640

    property int scaleFactor : 1//AppFramework.displayScaleFactor
    property int baseFontSize: 20 * scaleFactor
    property double titleFontScale: 1.7
    property double subTitleFontScale: 0.7

    property bool isSmallScreen: false
    property bool isPortrait: app.height > app.width //false

    onIsPortraitChanged: console.log ("isPortrait", isPortrait)
    //property bool isOnline: AppFramework.network.isOnline

    property bool featureServiceInfoComplete : false
    property string deviceOS: Qt.platform.os

    property string storagePath: "~/ArcGIS/Runtime/Data/DRE"
    property string gdbPath: storagePath+"/app.geodatabase"
    property bool gdbLoaded: true
    property bool welcomeBusy: false

    property string featuresUrl: "http://services.arcgis.com/Wl7Y1m92PbjtJs5n/arcgis/rest/services/KSPetro/FeatureServer"
    property string baseMapURL: "http://services.arcgisonline.com/arcgis/rest/services/ESRI_StreetMap_World_2D/MapServer"

    property variant selectedFeatureId: ""


    ServiceInfoTask {
        id: serviceInfoTask
        url: featuresUrl

        onFeatureServiceInfoStatusChanged: {

            if (featureServiceInfoStatus === Enums.FeatureServiceInfoStatusCompleted) {
                console.log("Service Info Received")
            } else if (featureServiceInfoStatus === Enums.FeatureServiceInfoStatusErrored) {
                console.log("Service Info NOT Received")
            }
        }
    }

    SpatialReference{
        id: sr
        wkid: 4267
    }

    Envelope{
        id: initialExtent
        xMin:-98.647319
        yMin:38.362661
        xMax: -98.564871
        yMax: 38.417745
        spatialReference: sr
    }

    GenerateGeodatabaseParameters {
        id: generateGeodatabaseParameters
    }
    GeodatabaseSyncTask {
        id: geodatabaseSyncTask
        url: featuresUrl
        onGenerateStatusChanged: {
            console.log("Status Changed: "+ generateStatus.valueOf())
            if(generateStatus.valueOf()==1){
                welcomePage.updateWelcomeBusyIndicator(true)
            }else{
                // welcomePage.updateWelcomeBusyIndicator(false)
            }
        }

        onGeodatabaseSyncStatusInfoChanged: {
            welcomePage.updateWelcomeStatus(geodatabaseSyncStatusInfo.statusString)
            console.log("Geodatabase Sync Status Changed: " + geodatabaseSyncStatusInfo.statusString)
        }

        onSyncStatusChanged: {
            console.log("Sync Status Changed: "+ syncStatus.toString()+ "ERROR: " + syncGeodatabaseError.message)
        }
    }
    Geodatabase {
        id: gdb
        path: geodatabaseSyncTask.geodatabasePath ? geodatabaseSyncTask.geodatabasePath : gdbPath //gdbPath? gdbPath: geodatabaseSyncTask.geodatabasePath //
        onValidChanged: {
            if(valid){
                welcomePage.callNext()
            }
        }
    }

    GeodatabaseFeatureTable{
        id: wellsFeatureTable
        geodatabase: gdb.valid ? gdb : null
        featureServiceLayerId: 0
    }

    GeodatabaseFeatureTable{
        id: fieldsFeatureTable
        geodatabase:  gdb.valid ? gdb : null
        featureServiceLayerId: 1
    }

    GeodatabaseFeatureServiceTable{
        id: wellsFeatureServiceTable
        url: "http://services.arcgis.com/Wl7Y1m92PbjtJs5n/arcgis/rest/services/KSPetro/FeatureServer/0"

        onApplyFeatureEditsErrorsChanged: {
            console.log(JSON.stringify(applyFeatureEditsErrors))
        }

        onApplyFeatureEditsStatusChanged: {
            console.log(applyFeatureEditsStatus)
            saveFlash.start()
        }
    }

    //    GeodatabaseFeatureTable{
    //        id: topsTable
    //        geodatabase: gdb.valid ? gdb: null
    //        featureServiceLayerId: 2
    //    }




    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: welcomePage;

        function showSelectorPage(){
            stackView.clear()
            push(selectorPageComp)
        }
    }


        Component {
            id: selectorPageComp
    SelectorPage{
        id: selectorPage

    }

     }

    //    Component {
    //        id: welcomePageComp
    WelcomePage{
        id: welcomePage
        onNext:{
            switch(message){
            case "newSelector": stackView.showSelectorPage(); break;
            }
        }
    }
    //    }


}

