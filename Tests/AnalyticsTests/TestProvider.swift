//
//  TestProvider.swift
//  
//
//  Created by Nikolay Fiantsev on 23.10.2021.
//

import Foundation
@testable import Analytics

class TestProvider: AnalyticsProvider {
  
  var events: [AnalyticsEvent] = []
  
  func setUp() {}
  
  func setUserId(_: String) {}
  
  func logEvent(_ event: AnalyticsEvent) {
    events.append(event)
  }
  
  func setUserProperty(_: UserProperty) {}
  
}
