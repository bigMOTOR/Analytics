//
//  AmplitudeProvider.swift
//  
//
//  Created by Nikolay Fiantsev on 28.05.2021.
//

import Foundation
import Amplitude

public struct AmplitudeProvider: AnalyticsProvider {
  private let _apiKey: String
  
  public init(apiKey: String) {
    self._apiKey = apiKey
  }
  
  public func setUp() {
    _setUp(apiKey: _apiKey)
  }
  
  public func logEvent(_ event: AnalyticsEvent) {
    Amplitude.instance().logEvent(event.name, withEventProperties: event.properties)
  }
  
  public func setUserId(_ id: String) {
    Amplitude.instance().setUserId(id, startNewSession: false)
  }
  
  public func setUserProperty(_ property: UserProperty) {
    let identify = AMPIdentify()
    
    property.dictionaryRepresentation.forEach { key, value in
      identify.set(key, value: value as? NSObject)
    }
    
    Amplitude.instance().identify(identify)
  }
    
  private func _setUp(apiKey: String) {
    // Enable sending automatic session events
    Amplitude.instance().trackingSessionEvents = true
    // Initialize SDK
    Amplitude.instance().initializeApiKey(apiKey)
  }
}
