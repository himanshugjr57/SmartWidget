//
//  WidgetPreview.swift
//  FastEvent
//
//  Created by Apps4World on 10/10/23.
//

import SwiftUI

/// Shows the preview for a widget
struct WidgetPreview: View {

    @Binding var currentStyle: WidgetLayoutType
    @Binding var eventTitle: String
    @Binding var eventDate: Date
    @Binding var eventTime: Date
    @Binding var backgroundColorStart: Color // Updated binding
    @Binding var backgroundColorEnd: Color // Updated binding
    @Binding var selectedIconName: String
    @Binding var fontColor: Color
    @Binding var location: WidgetLocation

    // MARK: - Main rendering function
    var body: some View {
        WidgetView(model: .init(data: [
            .title: eventTitle, .icon: selectedIconName,
            .date: eventDate.shortFormat, .time: eventTime.shortTimeFormat,
            .backgroundColorStart: backgroundColorStart.string, // Updated data key
            .backgroundColorEnd: backgroundColorEnd.string, // Updated data key
            .layoutStyle: currentStyle.rawValue,
            .fontColor: fontColor.string,
            .location: location.rawValue
        ]))
    }
}
