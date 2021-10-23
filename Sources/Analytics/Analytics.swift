import Foundation

private var _provider: AnalyticsProvider?
private var _deferedPropertiesStore: SafeCache<String, AnalyticsEventProperties> = SafeCache()

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
    switch event.logEventOnce {
    case true:
      guard !UserDefaults.standard.loggedEventsKeys.contains(event.name) else { return }
      UserDefaults.standard.appendLogEvent(event)
      _provider?.logEvent(event)
    case false:
      _provider?.logEvent(event)
    }
  }
  
  // MARK: - Deferred Events
  public static func logDeferred<T: DeferredConstructed>(_ event: T) {
    let storedPropertiesForEvent = _deferedPropertiesStore[event.name] ?? event.defaultAnalyticsEventProperties
    let enrichedEvent = EnrichedAnalyticsEvent(event, deferredParameters: storedPropertiesForEvent)
    logEvent(enrichedEvent)
    _deferedPropertiesStore[event.name] = nil
  }
  
  public static func setDeferredProperty<T: DeferredConstructed>(for event: T, key: T.DeferredProperty, value: Any) {
    var storedPropertiesForEvent = _deferedPropertiesStore[event.name] ?? event.defaultAnalyticsEventProperties
    storedPropertiesForEvent[key.rawValue] = value
    _deferedPropertiesStore[event.name] = storedPropertiesForEvent
  }
  
}

