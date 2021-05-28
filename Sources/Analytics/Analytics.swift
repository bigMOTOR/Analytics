import Foundation

private var _provider: AnalyticsProvider?

public enum Analytics {
  
  public static func register(_ provider: AnalyticsProvider) {
    _provider = provider
    _provider?.setUp()
  }
  
  public static func setUserId(_ id: String) {
    _provider?.setUserId(id)
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
  
}

