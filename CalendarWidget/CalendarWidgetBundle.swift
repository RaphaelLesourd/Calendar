//
//  CalendarWidgetBundle.swift
//  CalendarWidget
//
//  Created by Birkyboy on 19/11/2022.
//

import WidgetKit
import SwiftUI

@main
struct CalendarWidgetBundle: WidgetBundle {
    var body: some Widget {
        CalendarWidget()
        CalendarWidgetLiveActivity()
    }
}
