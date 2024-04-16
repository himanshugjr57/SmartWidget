//
//  FastEventWidget.swift
//  FastEventWidget
//
//  Created by Apps4World on 10/10/23.
//

import SwiftUI
import WidgetKit

/// Timeline provider
struct Provider: TimelineProvider {
    
    @ObservedObject var manager = DataManager()
    
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(), eventModel: nil)
    }

    @MainActor func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let event = self.manager.getObject(id: self.manager.selectedWidgetId)
        let entry = SimpleEntry(date: Date(), eventModel: event)
        completion(entry)
    }
    
    @MainActor func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        let event = self.manager.getSelectedWidget(withId: self.manager.selectedWidgetId)
        let event = self.manager.getObject(id: self.manager.selectedWidgetId)
        let entry = SimpleEntry(date: Date(), eventModel: event)
        completion(Timeline(entries: [entry], policy: .atEnd))
    }


//    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        Task {
//            await self.manager.loadSavedEvents { data in
//                let currentDate = Date()
//                var entries: [SimpleEntry] = []
//                for minuteOffset in 0..<5 {
//                    let event = self.manager.getSelectedWidget(withId: self.manager.selectedWidgetId)
//                    let entryDate = Calendar.current.date(byAdding: .second, value: minuteOffset, to: currentDate)!
//                    let entry = SimpleEntry(date: entryDate, eventModel: event)
//                    entries.append(entry)
//                }
//                let timeline = Timeline(entries: entries, policy: .atEnd)
//                completion(timeline)
//            }
//        }
//    }
}

/// Widget entry
struct SimpleEntry: TimelineEntry {
    let date: Date
    let eventModel: EventModel?
}

/// Widget view
struct FastEventWidgetEntryView : View {

    var entry: Provider.Entry
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            if let activeEvent = entry.eventModel {
                WidgetView(model: activeEvent, useRenderingMode: true)
            } else {
                SetupRequiredView
            }
        }
    }

    /// Widget Setup Required
    private var SetupRequiredView: some View {
        VStack {
            Image(systemName: "calendar.badge.exclamationmark").font(.system(size: 25))
            Text("Widget Event").font(.system(size: 15, weight: .semibold))
            Text("Launch the app and select/create an event")
                .font(.system(size: 12, weight: .light))
        }
        .multilineTextAlignment(.center).padding()
    }
}

struct EventTimesEntryView : View {

    var body: some View {
        VStack {
            Text("Hello")
            Text("Himanshu")
        }
    }
} // end EventTimesEntryView


/// Widget configuration
struct FastEventWidget: Widget {

    let kind: String = "FastEventWidget"

    // MARK: - Main rendering function
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
//            EventTimesEntryView()
//                .previewContext(WidgetPreviewContext(family: .systemSmall))
//                .containerBackground(.red.gradient, for: .widget)

            FastEventWidgetEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .containerBackground(.red.gradient, for: .widget)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)) { output in
                    WidgetCenter.shared.reloadAllTimelines()
                }
        }
        .contentMarginsDisabled()
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .configurationDisplayName("Your event")
        .description("Amazing event")
    }
}

// MARK: - Preview UI
#Preview(as: .systemSmall) {
    FastEventWidget()
} timeline: {
    SimpleEntry(date: .now, eventModel: nil)
}


// struct FastEventWidget: Widget {
//
//     let kind: String = "FastEventWidget"
//
//     // MARK: - Main rendering function
//     var body: some WidgetConfiguration {
//         StaticConfiguration(kind: kind, provider: Provider()) { entry in
// //            EventTimesEntryView()
// //                .previewContext(WidgetPreviewContext(family: .systemSmall))
//             
//             FastEventWidgetEntryView(entry: entry)
//                 .previewContext(WidgetPreviewContext(family: .systemSmall))
//                 .containerBackground(.red.gradient, for: .widget)
//         }
//         .contentMarginsDisabled()
// //        .configurationDisplayName("Fast Event")
// //        .description("Countdown widget for Home Screen and StandBy")
// //        .supportedFamilies([.systemSmall])
// //        .contentMarginsDisabled()
//     }
// }

