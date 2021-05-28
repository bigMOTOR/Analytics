//
//  AnalyticsProvider.swift
//  
//
//  Created by Nikolay Fiantsev on 28.05.2021.
//

import Foundation

public protocol AnalyticsProvider {
  func setUp()
  func setUserId(_: String)
  func logEvent(_ event: AnalyticsEvent)
}
