import XCTest
@testable import Analytics

final class AnalyticsTests: XCTestCase {
  
  var provider: TestProvider!
  
  override func setUp() {
    provider = TestProvider()
    Analytics.register(provider)
  }
  
  func testAnalyticEventHasName() {
    let someName = "SomeName"
    Analytics.logEvent(SimpleEvent(name: someName))
    XCTAssertEqual(provider.events.last?.name, someName)
  }
  
  func testAnalyticEventHasProperty() {
    let parameterKey = "SomeKey"
    Analytics.logEvent(SimpleEvent(properties: [parameterKey: true]))
    let eventParameterValue: Bool? = provider.events.last?.getProperty(key: parameterKey)
    XCTAssertEqual(eventParameterValue, true)
  }
  
  func testAnalyticEventContainsDeferredProperty() {
    let deferredPropertyKey = "DeferredKey"
    let deferredPropertyValue = "ABC123"
    Analytics.setDeferredProperty(key: deferredPropertyKey, value: deferredPropertyValue, for: SimpleEvent.name)
    Analytics.logEvent(SimpleEvent())
    let eventParameterValue: String? = provider.events.last?.getProperty(key: deferredPropertyKey)
    XCTAssertEqual(eventParameterValue, deferredPropertyValue)
  }

  func testAnalyticEventContainsDeferredPropertiesSepareteSended() {
    let deferredPropertyKeyA = "DeferredKeyA"
    let deferredPropertyValueA = true

    let deferredPropertyKeyB = "DeferredKeyB"
    let deferredPropertyValueB = 31102021
    
    Analytics.setDeferredProperty(key: deferredPropertyKeyA, value: deferredPropertyValueA, for: SimpleEvent.name)
    Analytics.setDeferred(properties: [deferredPropertyKeyB: deferredPropertyValueB], for: SimpleEvent.name)
    
    Analytics.logEvent(SimpleEvent())
    let eventParameters = provider.events.last
    let parameterValueA: Bool? = eventParameters?.getProperty(key: deferredPropertyKeyA)
    XCTAssertEqual(parameterValueA, deferredPropertyValueA)
    let parameterValueB: Int? = eventParameters?.getProperty(key: deferredPropertyKeyB)
    XCTAssertEqual(parameterValueB, deferredPropertyValueB)
  }
  
  func testAnalyticEventContainsDeferredPropertySetByArray() {
    let deferredPropertyKeyA = "DeferredKeyA"
    let deferredPropertyValueA = true

    let deferredPropertyKeyB = "DeferredKeyB"
    let deferredPropertyValueB = 31102021
    
    Analytics.setDeferred(properties: [deferredPropertyKeyA: deferredPropertyValueA, deferredPropertyKeyB: deferredPropertyValueB],
                          for: SimpleEvent.name)
    
    Analytics.logEvent(SimpleEvent())
    let eventParameters = provider.events.last
    let parameterValueA: Bool? = eventParameters?.getProperty(key: deferredPropertyKeyA)
    XCTAssertEqual(parameterValueA, deferredPropertyValueA)
    let parameterValueB: Int? = eventParameters?.getProperty(key: deferredPropertyKeyB)
    XCTAssertEqual(parameterValueB, deferredPropertyValueB)
  }

  func testAnalyticEventKeepsPropertiesAfterDeferredConstructedCalls() {
    let parameterKey = "SomeKey"
    Analytics.setDeferredProperty(key: "DeferredKeyA", value: 123, for: SimpleEvent.name)
    Analytics.logEvent(SimpleEvent(name: SimpleEvent.name, properties: [parameterKey: true]))
    let logged: Bool? = provider.events.last?.getProperty(key: parameterKey)
    XCTAssertEqual(logged, true)
  }

  func testAnalyticEventDeferredPropertiesUpdatesInitial() {
    let parameterKey = "SomeKey"
    Analytics.setDeferredProperty(key: parameterKey, value: 1, for: SimpleEvent.name)
    Analytics.logEvent(SimpleEvent(properties: [parameterKey: 2]))
    let logged: Int? = provider.events.last?.getProperty(key: parameterKey)
    XCTAssertEqual(logged, 1)
  }

  func testAnalyticEventMixDeferredAndInitialProperties() {
    let deferredPropertyKeyA = "KeyA"
    let deferredPropertyValueA = true

    let deferredPropertyKeyB = "KeyB"
    let deferredPropertyValueB = 31102021
    
    Analytics.setDeferredProperty(key: deferredPropertyKeyA, value: deferredPropertyValueA, for: SimpleEvent.name)
    Analytics.logEvent(SimpleEvent(properties: [deferredPropertyKeyB: deferredPropertyValueB]))
    
    let eventParameters = provider.events.last
    let parameterValueA: Bool? = eventParameters?.getProperty(key: deferredPropertyKeyA)
    XCTAssertEqual(parameterValueA, deferredPropertyValueA)
    let parameterValueB: Int? = eventParameters?.getProperty(key: deferredPropertyKeyB)
    XCTAssertEqual(parameterValueB, deferredPropertyValueB)
  }

  func testDeferredConstructedPropertiesCleanUpAfterEventLogged() {
    let parameterKey = "SomeKey"
    
    Analytics.setDeferredProperty(key: parameterKey, value: true, for: SimpleEvent.name)
    Analytics.logEvent(SimpleEvent())
    Analytics.logEvent(SimpleEvent())
    let logged: Bool? = provider.events.last?.getProperty(key: parameterKey)
    XCTAssertNil(logged)
  }
  
}

private extension AnalyticsEvent {
  func getProperty<T>(key: String) -> T? {
    return properties.flatMap { $0[key] as? T }
  }
}

private struct SimpleEvent: AnalyticsEvent {
  
  static let name = "MyEvent"
  
  let name: String
  let properties: AnalyticsEventProperties?
  
  init(name: String = Self.name, properties: AnalyticsEventProperties? = nil) {
    self.name = name
    self.properties = properties
  }
  
}
