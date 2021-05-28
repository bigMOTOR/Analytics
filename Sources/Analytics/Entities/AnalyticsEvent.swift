//
//  AnalyticsEvent.swift
//  
//
//  Created by Nikolay Fiantsev on 28.05.2021.
//

import Foundation

public typealias AnalyticsEventProperties = [String: Any]

public protocol AnalyticsEvent {
  var name: String { get }
  var parameters: AnalyticsEventProperties? { get }
  var logEventOnce: Bool { get }
}

public extension AnalyticsEvent {
  var parameters: AnalyticsEventProperties? {
    return nil
  }
  
  var logEventOnce: Bool {
    return false
  }
}
