//
//  AmplitudeProvider.swift
//  
//
//  Created by Nikolay Fiantsev on 28.05.2021.
//

import Foundation
import AmplitudeSwift

public final class AmplitudeProvider: AnalyticsProvider {
  private let _apiKey: String
  private var _amplitude: Amplitude?
  
  public init(apiKey: String) {
    self._apiKey = apiKey
  }
  
  public func setUp() {
    _amplitude = Amplitude(
      configuration: Configuration(
        apiKey: _apiKey,
        autocapture: .sessions
      )
    )
  }
  
  public func logEvent(_ event: AnalyticsEvent) {
    guard let amplitude = _amplitude else { assertionFailure("Amplitude not configured!"); return }
    amplitude.track(event: .init(eventType: event.name, eventProperties: event.properties))
  }
  
  public func setUserId(_ id: String) {
    guard let amplitude = _amplitude else { assertionFailure("Amplitude not configured!"); return }
    amplitude.setUserId(userId: id)
  }
  
  public func setUserProperty(_ property: UserProperty) {
    guard let amplitude = _amplitude else { assertionFailure("Amplitude not configured!"); return }
    let identify = Identify()
    
    property.dictionaryRepresentation.forEach { key, value in
      identify.set(property: key, value: value)
    }
    
    amplitude.identify(identify: identify)
  }
}
