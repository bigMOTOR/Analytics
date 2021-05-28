//
//  UserDefaultsExtension.swift
//  
//
//  Created by Nikolay Fiantsev on 28.05.2021.
//

import Foundation

extension UserDefaults {
  var loggedEventsKeys: [String] {
    get { UserDefaults.standard.stringArray(forKey: #function) ?? [] }
    set { UserDefaults.standard.set(newValue, forKey: #function) }
  }
  
  func appendLogEvent(_ event: AnalyticsEvent) {
    guard !loggedEventsKeys.contains(event.name) else { return }
    loggedEventsKeys.append(event.name)
  }
}
