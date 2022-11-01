import QtQuick 2.5
import QtQuick.Window 2.2

Image {
    id: root
    source: "images/background.jpg"
    fillMode: Image.PreserveAspectCrop
    clip: true

    property int stage

    onStageChanged: {
        if (stage == 1) {
            introAnimation.running = true
        }
    }
    Image {
        id: img1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.verticalCenter
        anchors.bottomMargin: -50

        source: "images/kde.svgz"
        sourceSize: Qt.size( root.height* 0.15,root.height* 0.15)
    }
    
    Rectangle {
        radius: 4
        color: "#222222"
        anchors {
            top: img1.bottom
            topMargin: 48
            horizontalCenter: img1.horizontalCenter
        }
        height: 6
        width: root.width*0.2
        Rectangle {
            radius: 4
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            width: (parent.width / 6) * (stage - 1)
            color: "#E95420"
            Behavior on width {
                PropertyAnimation {
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }

    Row {
            spacing: units.smallSpacing*2
            anchors {
                bottom: parent.bottom
                right: parent.right
                margins: units.gridUnit
            }
            Text {
                color: "#eff0f1"
                // Work around Qt bug where NativeRendering breaks for non-integer scale factors
                // https://bugreports.qt.io/browse/QTBUG-67007
                renderType: Screen.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering
                anchors.verticalCenter: parent.verticalCenter
                text: i18ndc("plasma_lookandfeel_org.kde.lookandfeel", "This is the first text the user sees while starting in the splash screen, should be translated as something short, is a form that can be seen on a product. Plasma is the project name so shouldn't be translated.", "Plasma made by KDE")
            }
        }

    SequentialAnimation {
        id: introAnimation
        running: false


        ParallelAnimation {
            loops: Animation.Infinite
            SequentialAnimation{
                PropertyAnimation {
                property: "scale"
                target: img1
                from: 0.9
                to: 1.1
                duration: 800
                easing.type: Easing.InBack
                }

                PropertyAnimation {
                property: "scale"
                target: img1
                from: 1.1
                to: 0.9
                duration: 800
                easing.type:Easing.OutBack
                }

            }
        }
    }
}

