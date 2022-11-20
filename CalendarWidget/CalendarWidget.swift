//
//  CalendarWidget.swift
//  CalendarWidget
//
//  Created by Birkyboy on 19/11/2022.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> DayEntry {
        DayEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (DayEntry) -> ()) {
        let entry = DayEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [DayEntry] = []
        
        // Generate a timeline consisting of 7 entries a day apart, starting from the current date.
        let currentDate = Date()
        for dayOffset in 0 ..< 7 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let startOfDate = Calendar.current.startOfDay(for: entryDate)
            let entry = DayEntry(date: startOfDate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct DayEntry: TimelineEntry {
    let date: Date
}

struct CalendarWidgetEntryView : View {
    var entry: DayEntry
    
    private let tintColor: Color = .purple
    private let gradient = Gradient(colors: [.purple, .white])
    private let backgroundColor: Color = Color(hue: 0.8, saturation: 1, brightness: 0.3, opacity: 1)
    private var calendar: Calendar {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        return calendar
    }
    private var daysInMonth: CGFloat {
        let range = calendar.range(of: .day, in: .month, for: entry.date)
        return CGFloat(range?.count ?? 0)
    }
    private var currentDay: CGFloat {
        CGFloat(calendar.component(.day, from: entry.date))
    }
    
    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(backgroundColor.gradient)
            dayGauge
            dateView
            day
        }
    }
  
    var day: some View {
        Text(entry.date.currentDayDisplayFormat)
            .foregroundColor(.white.opacity(0.95))
            .font(.system(size: 70, weight: .bold, design: .default))
    }
    
    var dateView: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            Text(entry.date.currentMonthDisplayFormat.uppercased())
                .foregroundColor(.white.opacity(0.8))
                .font(.system(size: 14, weight: .bold, design: .default))
                .minimumScaleFactor(0.6)
                .lineLimit(1)
            Text(entry.date.currentWeekdayDisplayFormat.uppercased())
                .foregroundColor(.white.opacity(0.6))
                .font(.system(size: 10, weight: .bold, design: .default))
                .minimumScaleFactor(0.6)
                .lineLimit(1)
        }
        .padding()
    }
    
    var dayGauge: some View {
        Gauge(value: currentDay, in: 0...daysInMonth) {}
            .gaugeStyle(.accessoryCircular)
            .tint(gradient)
            .scaleEffect(2.6)
            .opacity(0.2)
            .padding(.top)
    }
}

struct CalendarWidget: Widget {
    let kind: String = "CalendarWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CalendarWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Calendar Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}

struct CalendarWidget_Previews: PreviewProvider {
    static var previews: some View {
        CalendarWidgetEntryView(entry: DayEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}


extension Date {
    var currentMonthDisplayFormat: String {
        self.formatted(.dateTime.month(.wide))
    }
    
    var currentWeekdayDisplayFormat: String {
        self.formatted(.dateTime.weekday(.wide))
    }
    
    var currentDayDisplayFormat: String {
        self.formatted(.dateTime.day(.twoDigits))
    }
}
