/*
 *  Copyright (C) 2019 cupnoodles <cupn8dles@gmail.com>
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

import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.5

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kquickcontrolsaddons 2.0 as KQuickAddons
import org.kde.kirigami 2.5 as Kirigami

Kirigami.FormLayout {

    property alias flow: flowComboBox.value
    property alias columns: columnsSpinBox.value
    property alias alwaysMaxColumns: alwaysMaxColumnsCheckbox.checked
    property alias enableSubtitles: enableSubtitlesCheckbox.checked
    property alias labelsPosition: labelsPositionComboBox.value
    property alias iconSize: iconSizeSlider.iconSize

    property alias labelsPositionCurrentValue: labelsPositionComboBox.currentValue
    property alias iconSizeSliderCurrentIconSize: iconSizeSlider.currentIconSize
    property alias flowComboBoxCurrentFlow: iconSizeSlider.currentIconSize

    ComboBox {
        id: flowComboBox
        Kirigami.FormData.label: i18n("Flow:")

        property int value: model[currentIndex]["value"]
        property int currentFlow: GridView.FlowLeftToRight
        currentIndex: flowToIndex(currentFlow)

        textRole: "label"
        model: [
            {
                label: i18n("Rows"),
                value: GridView.FlowLeftToRight,
            },
            {
                label: i18n("Columns"),
                value: GridView.FlowTopToBottom,
            }
        ]

        onCurrentIndexChanged: value = model[currentIndex]["value"]

        function flowToIndex(flow) {
            for (var i = 0; i < model.length; i++) {
                if (model[i]["value"] == flow) {
                    return i;
                }
            }
            return 0;
        }
    }

    SpinBox {
        id: columnsSpinBox
        Kirigami.FormData.label: i18n("Maximum columns on screen:")
        from: 1.0 // will be minimumValue in newer Qt
    }

    CheckBox {
        id: alwaysMaxColumnsCheckbox
        text: i18n("Always use maximum columns")
    }
    Slider {
        id: iconSizeSlider
        Kirigami.FormData.label: i18n("Icon size:")
        Layout.fillWidth: true
        from: 0
        to: 5
        stepSize: 1
        property int currentIconSize: 32
        value: iconSizes.indexOf(currentIconSize)

        property int iconSize: iconSizes[value]
        property variant iconSizes : [
            units.iconSizes.small, units.iconSizes.smallMedium,
            units.iconSizes.medium, units.iconSizes.large,
            units.iconSizes.huge, units.iconSizes.enormous
        ]

        onValueChanged: iconSize = iconSizes[value]
    }

    RowLayout {
        Layout.fillWidth: true

        Label {
            text: i18n("Small")
            Layout.alignment: Qt.AlignLeft
        }

        Item {
            Layout.fillWidth: true
        }

        Label {
            text: i18n("Large")
            Layout.alignment: Qt.AlignRight
        }
    }


    ComboBox {
        id: labelsPositionComboBox
        Kirigami.FormData.label: i18n("Label position:")

        property string value: model[currentIndex]["value"]

        property string currentValue: right
        currentIndex: positionToIndex(currentValue)

        textRole: "label"
        model: [
            {
                label: i18n("Right"),
                value: "right",
            },
            {
                label: i18n("Bottom"),
                value: "bottom",
            },
            {
                label: i18n("Hidden"),
                value: "hide",
            }
        ]

        onCurrentIndexChanged: value = model[currentIndex]["value"]

        function positionToIndex(position) {
            for (var i = 0; i < model.length; i++) {
                if (model[i]["value"] == position) {
                    return i;
                }
            }
            return 0;
        }
    }

    CheckBox {
        id: enableSubtitlesCheckbox
        enabled: (labelsPositionComboBox.value != "hide")
        text: i18n("Display subtitles")
    }
}
