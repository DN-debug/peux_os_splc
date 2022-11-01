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

ColumnLayout {

    property alias cfg_applicationsUseFavoritesConfig: applicationsUseFavoritesConfigCheckbox.checked

    property alias cfg_applicationsFlow: gridViewSettings.flow
    property alias cfg_applicationsColumns: gridViewSettings.columns
    property alias cfg_applicationsAlwaysMaxColumns: gridViewSettings.alwaysMaxColumns
    property alias cfg_applicationsEnableSubtitles: gridViewSettings.enableSubtitles
    property alias cfg_applicationsLabelsPosition: gridViewSettings.labelsPosition
    property alias cfg_applicationsIconSize: gridViewSettings.iconSize

    Kirigami.FormLayout {
        CheckBox {
            id: applicationsUseFavoritesConfigCheckbox
            text: i18n("Use the same parameters as Favorites tab")
        }
    }

    ConfigGridView {
        id: gridViewSettings
        labelsPositionCurrentValue: plasmoid.configuration.applicationsLabelsPosition
        iconSizeSliderCurrentIconSize: plasmoid.configuration.applicationsIconSize
        flowComboBoxCurrentFlow: plasmoid.configuration.applicationsFlow
        enabled: (!applicationsUseFavoritesConfigCheckbox.checked)
    }

    Item {
        Layout.fillHeight: true
    }
}
