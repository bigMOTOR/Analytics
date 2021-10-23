//
//  DeferredConstructed.swift
//  
//
//  Created by Nikolay Fiantsev on 23.10.2021.
//

import Foundation

public protocol DeferredConstructed where Self: AnalyticsEvent {
  associatedtype DeferredProperty: RawRepresentable, Hashable where DeferredProperty.RawValue == String
  
  var defaultParameters: [DeferredProperty: Any] { get }
}

public extension DeferredConstructed {
  var defaultParameters: [DeferredProperty: Any] {
    return [:]
  }
}

extension DeferredConstructed {
  var defaultAnalyticsEventProperties: AnalyticsEventProperties {
    return Dictionary(uniqueKeysWithValues: defaultParameters.map { key, value in (key.rawValue, value) })
  }
}
