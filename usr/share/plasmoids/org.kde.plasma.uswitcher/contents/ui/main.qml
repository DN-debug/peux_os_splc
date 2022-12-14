/*
 *  Copyright 2015 Kai Uwe Broulik <kde@privat.broulik.de>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  2.010-1301, USA.
 */

import QtQuick 2.2
import QtQuick.Controls 1.1 as QtControls
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kcoreaddons 1.0 as KCoreAddons // kuser
import org.kde.kquickcontrolsaddons 2.0 // kcmshell
import org.kde.kirigami 2.13 as Kirigami

import org.kde.plasma.private.sessions 2.0 as Sessions

Item {
    id: root
    readonly property bool isVertical: plasmoid.formFactor === PlasmaCore.Types.Vertical

    readonly property string displayedName: showFullName ? kuser.fullName : kuser.loginName

    readonly property bool showFace: plasmoid.configuration.showFace
    readonly property bool showSett: plasmoid.configuration.showSett
    readonly property bool showName: plasmoid.configuration.showName
    property var iconSett: plasmoid.configuration.icon

    readonly property bool showFullName: plasmoid.configuration.showFullName

    // TTY number and X display
    readonly property bool showTechnicalInfo: plasmoid.configuration.showTechnicalInfo

    Plasmoid.switchWidth: units.gridUnit * 10
    Plasmoid.switchHeight: units.gridUnit * 12

    Plasmoid.toolTipTextFormat: Text.StyledText
    Plasmoid.toolTipSubText: i18n("You are logged in as <b>%1</b>", displayedName)

    PlasmaCore.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        property var callbacks: ({})
        onNewData: {
            var stdout = data["stdout"]

            if (callbacks[sourceName] !== undefined) {
                callbacks[sourceName](stdout);
            }

            exited(sourceName, stdout)
            disconnectSource(sourceName) // cmd finished
        }

        function exec(cmd, onNewDataCallback) {
            if (onNewDataCallback !== undefined){
                callbacks[cmd] = onNewDataCallback
            }
            connectSource(cmd)

        }
        signal exited(string sourceName, string stdout)

    }

    Binding {
        target: plasmoid
        property: "icon"
        value: kuser.faceIconUrl
        // revert to the plasmoid icon if no face given
        when: !!kuser.faceIconUrl
    }

    KCoreAddons.KUser {
        id: kuser
    }

    Plasmoid.compactRepresentation: MouseArea {
        id: compactRoot

        // Taken from DigitalClock to ensure uniform sizing when next to each other
        readonly property bool tooSmall: plasmoid.formFactor === PlasmaCore.Types.Horizontal && Math.round(2 * (compactRoot.height / 5)) <= theme.smallestFont.pixelSize

        Layout.minimumWidth: isVertical ? 0 : compactRow.implicitWidth
        Layout.maximumWidth: isVertical ? Infinity : Layout.minimumWidth
        Layout.preferredWidth: isVertical ? undefined : Layout.minimumWidth

        Layout.minimumHeight: isVertical ? label.height : theme.smallestFont.pixelSize
        Layout.maximumHeight: isVertical ? Layout.minimumHeight : Infinity
        Layout.preferredHeight: isVertical ? Layout.minimumHeight : theme.mSize(theme.defaultFont).height * 2

        onClicked: plasmoid.expanded = !plasmoid.expanded

        Row {
            id: compactRow

            anchors.centerIn: parent
            spacing: units.smallSpacing

            Kirigami.Avatar {
                id: icon
                width: compactRoot.height
                height: compactRoot.height
                source: visible ? (kuser.faceIconUrl || "user-identity") : ""
                visible: root.showFace
            }

            PlasmaCore.IconItem {
                id: icon2
                width: height
                height: compactRoot.height
                Layout.preferredWidth: height
                source: visible ? (iconSett || "avatar-default-symbolic") : ""
                visible: root.showSett
            }

            PlasmaComponents.Label {
                id: label
                text: root.displayedName
                height: compactRoot.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.NoWrap
                fontSizeMode: Text.VerticalFit
                font.pixelSize: tooSmall ? theme.defaultFont.pixelSize : units.roundToIconSize(units.gridUnit * 2)
                minimumPointSize: theme.smallesFont.pointSize
                visible: root.showName
            }
        }
    }

    Plasmoid.fullRepresentation: Item {
        id: fullRoot

        Layout.preferredWidth: units.gridUnit * 12
        Layout.preferredHeight: Math.min(Screen.height * 0.5, column.contentHeight)

        PlasmaCore.DataSource {
            id: pmEngine
            engine: "powermanagement"
            connectedSources: ["PowerDevil", "Sleep States"]

            function performOperation(what) {
                var service = serviceForSource("PowerDevil")
                var operation = service.operationDescription(what)
                service.startOperationCall(operation)
            }
        }

        Sessions.SessionsModel {
            id: sessionsModel
        }

        Connections {
            target: plasmoid
            onExpandedChanged: {
                if (plasmoid.expanded) {
                    sessionsModel.reload()
                }
            }
        }

        PlasmaComponents.Highlight {
            id: delegateHighlight
            visible: false
            z: -1 // otherwise it shows ontop of the icon/label and tints them slightly
        }

        ColumnLayout {
            id: column

            // there doesn't seem a more sensible way of getting this due to the expanding ListView
            readonly property int contentHeight: aboutComputerItem.height + systemSettingsItem.height + systemMonitorItem.height + 2*separatorItem.height + currentUserItem.height + userList.contentHeight
                                               + (newSessionButton.visible ? newSessionButton.height : 0)
                                               + (lockScreenButton.visible ? lockScreenButton.height : 0)
                                               + suspendButton.height + leaveButton.height

            anchors.fill: parent

            spacing: 0

            ListDelegate {
                id: aboutComputerItem
                text: i18n("About This Computer")
                icon: "help-about"
                highlight: delegateHighlight
                onClicked: {
                    executable.exec("kinfocenter");
                }
            }

            ListDelegate {
                id: systemMonitorItem
                text: i18n("System Monitor")
                icon: "view-process-tree"
                highlight: delegateHighlight
                onClicked: {
                    executable.exec("ksysguard");
                }
            }

            ListDelegate {
                id: systemSettingsItem
                text: i18n("System Settings")
                icon: "settings-configure"
                highlight: delegateHighlight
                onClicked: {
                    executable.exec("systemsettings5");
                }
            }

            Rectangle {
                id: separatorItem
                Layout.alignment: Qt.AlignCenter
                width: parent
                height: units.smallSpacing*2
                opacity: 0
            }

            ListDelegate {
                id: currentUserItem
                text: root.displayedName
                subText: i18n("<i>Current user</i>")
                icon: "user-identity"
                interactive: false
                interactiveIcon: true
                onIconClicked: KCMShell.open("user_manager")
            }

            PlasmaExtras.ScrollArea {
                Layout.fillWidth: true
                Layout.fillHeight: true

                ListView {
                    id: userList
                    model: sessionsModel

                    highlight: PlasmaComponents.Highlight {}
                    highlightMoveDuration: 0

                    delegate: ListDelegate {
                        width: userList.width
                        text: {
                            if (!model.session) {
                                return i18nc("Nobody logged in on that session", "Unused")
                            }

                            if (model.realName && root.showFullName) {
                                return model.realName
                            }

                            return model.name
                        }
                        icon: "user-identity"
                        subText: {
                            if (!root.showTechnicalInfo) {
                                return ""
                            }

                            if (model.isTty) {
                                return i18nc("User logged in on console number", "TTY %1", model.vtNumber)
                            } else if (model.displayNumber) {
                                return i18nc("User logged in on console (X display number)", "on %1 (%2)", model.vtNumber, model.displayNumber)
                            }
                            return ""
                        }

                        onClicked: sessionsModel.switchUser(model.vtNumber, sessionsModel.shouldLock)
                        onContainsMouseChanged: {
                            if (containsMouse) {
                                userList.currentIndex = index
                            } else {
                                userList.currentIndex = -1
                            }
                        }
                    }
                }
            }


            ListDelegate {
                id: newSessionButton
                text: i18n("New Session")
                highlight: delegateHighlight
                visible: sessionsModel.canStartNewSession
                onClicked: sessionsModel.startNewSession(sessionsModel.shouldLock)
            }

            Rectangle {
                id: separatorItem3
                Layout.alignment: Qt.AlignCenter
                width: parent
                height: units.smallSpacing*2
                opacity: 0
            }

            ListDelegate {
                id: lockScreenButton
                text: i18n("Lock Screen")
                icon: "system-lock-screen"
                highlight: delegateHighlight
                enabled: pmEngine.data["Sleep States"]["LockScreen"]
                visible: enabled
                onClicked: pmEngine.performOperation("lockScreen")
            }

            ListDelegate {
                id: suspendButton
                text: i18n("Suspend")
                highlight: delegateHighlight
                icon: "system-suspend"
                onClicked: pmEngine.performOperation("suspend")
            }

            ListDelegate {
                id: leaveButton
                text: i18nc("Show a dialog with options to logout/shutdown/restart", "Leave...")
                highlight: delegateHighlight
                icon: "system-log-out"
                onClicked: pmEngine.performOperation("requestShutDown")
            }
        }
    }
}
