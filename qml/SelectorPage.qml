import QtQuick 2.0

import ArcGIS.Runtime 10.26
//import ArcGIS.AppFramework 1.0
//import ArcGIS.AppFramework.Controls 1.0
//import ArcGIS.AppFramework.Runtime 1.0

Rectangle {
    width: parent.width
    height: parent.height

    signal next(string message)
    signal previous(string message)


    property int hitFeatureId
    property variant attrValue

    Map{
        id: map
        anchors.fill: parent
        wrapAroundEnabled: true
        rotationByPinchingEnabled: true
        magnifierOnPressAndHoldEnabled: true
        mapPanningByMagnifierEnabled: true

        ArcGISTiledMapServiceLayer {
            url: baseMapURL
        }

        onStatusChanged:{
            if(status==Enums.MapStatusReady)
                extent = initialExtent;
        }

        FeatureLayer{
            id: wellsLayer
            featureTable: wellsFeatureTable

            function hitTestFeatures(x,y) {
                console.log(wellsFeatureTable.tableName )
                var tolerance = Qt.platform.os === "ios" || Qt.platform.os === "android" ? 4 : 1;
                var featureIds = wellsLayer.findFeatures(x, y, tolerance*scaleFactor, 1);

                if(!featureIds.length==0){
                    selectedFeatureId = featureIds[0]
                    var selectedFeature = wellsFeatureServiceTable.feature(selectedFeatureId)
                    selectFeature(selectedFeatureId)
                    console.log("here")
                }
            }
            onStatusChanged: {
                console.log("something " )

            }
        }

        onMouseClicked: {
            wellsLayer.clearSelection()
            wellsLayer.hitTestFeatures(mouse.x, mouse.y)
        }

    }




}

