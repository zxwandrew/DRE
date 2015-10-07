import QtQuick 2.0

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import ArcGIS.AppFramework.Runtime 1.0
import ArcGIS.AppFramework.Runtime.Controls 1.0
import ArcGIS.AppFramework.Runtime 1.0

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

    }


}

