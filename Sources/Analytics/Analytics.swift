import Foundation

private var _provider: AnalyticsProvider?
private var _deferredPropertiesMutationsStore: SafeCache<String, (AnalyticsEventProperties)->AnalyticsEventProperties> = SafeCache()

public enum Analytics {
  
  public static func register(_ provider: AnalyticsProvider) {
    _provider = provider
    _provider?.setUp()
  }
  
  public static func setUserId(_ id: String) {
    _provider?.setUserId(id)
  }
  
  public static func setUserProperty(_ property: UserProperty) {
    _provider?.setUserProperty(property)
  }
  
  public static func logEvent(_ event: AnalyticsEvent) {
    let storedMutationForEvent = _deferredPropertiesMutationsStore[event.name] ?? { return $0 }
    
    let eventToLog = EnrichedAnalyticsEvent(name: event.name,
                                            properties: storedMutationForEvent(event.properties ?? [:]),
                                            logEventOnce: event.logEventOnce)
    
    _deferredPropertiesMutationsStore[event.name] = nil
    
    switch eventToLog.logEventOnce {
    case true:
      guard !UserDefaults.standard.loggedEventsKeys.contains(eventToLog.name) else { return }
      UserDefaults.standard.appendLogEvent(eventToLog)
      _provider?.logEvent(eventToLog)
    case false:
      _provider?.logEvent(eventToLog)
    }
  }
  
  // MARK: - Deferred Event Properties
  public static func setDeferredProperty(key: String, value: Any, for eventName: String) {
    Self.setDeferred(properties: [key: value], for: eventName)
  }
  
  public static func setDeferred(properties deferredProperties: [String: Any], for eventName: String) {
    
    let propertiesMutation: (AnalyticsEventProperties)->AnalyticsEventProperties = { properties in
      properties.merging(deferredProperties) { (_, new) in new }
    }
    
    let storedMutationForEvent = _deferredPropertiesMutationsStore[eventName] ?? { return $0 }
    let mutationsComposition = storedMutationForEvent |> propertiesMutation
    _deferredPropertiesMutationsStore[eventName] = mutationsComposition
  }
  
}

