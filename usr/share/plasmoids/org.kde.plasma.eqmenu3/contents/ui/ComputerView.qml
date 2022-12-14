/*
    Copyright (C) 2011  Martin Gräßlin <mgraesslin@kde.org>
    Copyright (C) 2012 Marco Martin <mart@kde.org>
    Copyright 2014 Sebastian Kügler <sebas@kde.org>
    Copyright (C) 2015-2018  Eike Hein <hein@kde.org>
    Copyright (C) 2016 Jonathan Liu <net147@gmail.com>
    Copyright (C) 2016 Kai Uwe Broulik <kde@privat.broulik.de>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/
import QtQuick 2.0
import org.kde.kquickcontrolsaddons 2.0 as KQuickControlsAddons

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.draganddrop 2.0

import org.kde.plasma.private.kicker 0.1 as Kicker

Item {
    anchors.fill: parent
    anchors.topMargin: units.largeSpacing

    objectName: "ComputerView"

    property GridView gridView: favoritesView.gridView

    function decrementCurrentIndex() {
        favoritesView.decrementCurrentIndex();
    }

    function incrementCurrentIndex() {
        favoritesView.incrementCurrentIndex();
    }

    function deactivateCurrentIndex() {
        return favoritesView.deactivateCurrentIndex();
    }

    function activateCurrentIndex(start) {
        return favoritesView.activateCurrentIndex(start);
    }

    function openContextMenu() {
        favoritesView.currentItem.openActionMenu();
    }

    // QQuickItem::isAncestorOf is not invokable...
    function isChildOf(item, parent) {
        if (!item || !parent) {
            return false;
        }

        if (item.parent === parent) {
            return true;
        }

        return isChildOf(item, item.parent);
    }

    DropArea {
        anchors.fill: parent
        enabled: plasmoid.immutability !== PlasmaCore.Types.SystemImmutable

        function syncTarget(event) {
            if (favoritesView.animating) {
                return;
            }

            var pos = mapToItem(gridView.contentItem, event.x, event.y);
            var above = gridView.itemAt(pos.x, pos.y);

            var source = kickoff.dragSource;

            if (above && above !== source && isChildOf(source, favoritesView)) {
                favoritesView.model.moveRow(source.itemIndex, above.itemIndex);
                // itemIndex changes directly after moving,
                // we can just set the currentIndex to it then.
                favoritesView.currentIndex = source.itemIndex;
            }
        }

        onDragEnter: syncTarget(event)

        onDragLeave: {
            // restore favorites order if the user
            // drags the item outside (e.g. to the desktop)
            var source = kickoff.dragSource;
            if (isChildOf(source, favoritesView)) {
                favoritesView.model.moveRow(source.itemIndex, kickoff.dragStartRow);
            }
        }
        onDragMove: {
            syncTarget(event);
        }
    }

    Transition {
        id: moveTransition
        SequentialAnimation {
            PropertyAction { target: favoritesView; property: "animating"; value: true }

            NumberAnimation {
                duration: favoritesView.animationDuration
                properties: "x, y"
                easing.type: Easing.OutQuad
            }

            PropertyAction { target: favoritesView; property: "animating"; value: false }
        }
    }

    Connections {
        target: plasmoid
        onExpandedChanged: {
            if (!expanded) {
                favoritesView.currentIndex = -1;
            }
        }
    }

    KickoffGridView {
        id: favoritesView

        anchors.fill: parent

        property bool animating: false
        property int animationDuration: resetAnimationDurationTimer.interval

        interactive: contentHeight > height

        move: moveTransition
        moveDisplaced: moveTransition

        flow: plasmoid.configuration.applicationsUseFavoritesConfig ?
            plasmoid.configuration.favoritesFlow : plasmoid.configuration.applicationsFlow
        alwaysMaxColumns: plasmoid.configuration.applicationsUseFavoritesConfig ?
            plasmoid.configuration.favoritesAlwaysMaxColumns : plasmoid.configuration.applicationsAlwaysMaxColumns
        columns: plasmoid.configuration.applicationsUseFavoritesConfig ?
            plasmoid.configuration.favoritesColumns : plasmoid.configuration.applicationsColumns
        iconSize: plasmoid.configuration.applicationsUseFavoritesConfig ?
            plasmoid.configuration.favoritesIconSize : plasmoid.configuration.applicationsIconSize
        enableSubtitles: plasmoid.configuration.applicationsUseFavoritesConfig ?
            plasmoid.configuration.favoritesEnableSubtitles : plasmoid.configuration.applicationsEnableSubtitles
        labelPosition: plasmoid.configuration.applicationsUseFavoritesConfig ?
            plasmoid.configuration.favoritesLabelsPosition : plasmoid.configuration.applicationsLabelsPosition


        model: Kicker.ComputerModel {
        id: computerModel

        appNameFormat: rootModel.appNameFormat

        appletInterface: plasmoid

        favoritesModel: globalFavorites

        Component.onCompleted: {
            systemApplications = plasmoid.configuration.systemApplications;
        }
    }

        onCountChanged: {
            animationDuration = 0;
            resetAnimationDurationTimer.start();
        }
    }

    Timer {
        id: resetAnimationDurationTimer

        interval: 150

        onTriggered: favoritesView.animationDuration = interval - 20
    }

}
