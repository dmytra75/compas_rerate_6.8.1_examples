// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


import QtSensors

ApplicationWindow {
    id: root

    readonly property int defaultFontSize: 22
    readonly property int imageSize: width / 2

    // width: width
    // height: height
    visible: true
    title: "Sensors Showcase"

    header : ToolBar {
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            ToolButton {
                id: back
                text: qsTr("Back")
                font.pixelSize: root.defaultFontSize - 4
                visible: stack.depth > 1
                onClicked: {
                    stack.pop();
                    heading.text = root.title;
                }
                Layout.alignment: Qt.AlignLeft
            }
            Label {
                id: heading
                text: root.title
                font.pixelSize: root.defaultFontSize
                font.weight: Font.Medium
                verticalAlignment: Qt.AlignVCenter
                Layout.alignment: Qt.AlignCenter
                Layout.preferredHeight: 55
            }
            Item {
                visible: back.visible
                Layout.preferredWidth: back.width
            }
        }
    }

    StackView {
        id: stack

        // Pushes the object and forwards the properties
        function pusher(object : string) : void {
            // Trim the suffix and set it as new heading
            heading.text = object.split(".")[0]
            return stack.push(object, {
                fontSize: root.defaultFontSize,
                imageSize: root.imageSize
            })
        }

        anchors.fill: parent
        anchors.margins: width / 12

        initialItem: Item {
            id: rootCompass

            // required property int fontSize
            // required property int imageSize
            property alias isActive: compass.active

            property real azimuth: 30

            Compass {
                id: compass
                active: true
                dataRate: 7
                onReadingChanged: rootCompass.azimuth = -(reading as CompassReading).azimuth
            }

            ColumnLayout {
                id: layout

                anchors.fill: parent
                spacing: 10

                Image {
                    id: arrow

                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: rootCompass.imageSize * 1.25
                    Layout.fillHeight: true

                    source: "images/compass.svg"
                    fillMode: Image.PreserveAspectFit
                    rotation: rootCompass.azimuth
                }

                Rectangle {
                    id: separator

                    Layout.topMargin: 10
                    Layout.preferredWidth: parent.width * 0.75
                    Layout.preferredHeight: 1
                    Layout.alignment: Qt.AlignHCenter
                    color: "black"
                }

                Text {
                    id: info
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.topMargin: 10
                    text: "Azimuth: " + rootCompass.azimuth.toFixed(2) + "°"
                    font.pixelSize: defaultFontSize
                }
            }
        }

    }

}
