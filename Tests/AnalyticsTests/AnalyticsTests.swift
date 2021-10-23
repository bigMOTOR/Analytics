import XCTest
@testable import Analytics

final class AnalyticsTests: XCTestCase {
  
  var provider: TestProvider!
  
  override func setUp() {
    provider = TestProvider()
    Analytics.register(provider)
  }
  
  func testDeferredConstructedEventContainsDeferredProperty() {
    Analytics.setDeferredProperty(for: TestEvent.just, key: .keyA, value: true)
    Analytics.logDeferred(TestEvent.just)
    let logged: Bool? = provider.getLoggedDeferredProperty(eventIdx: 0, for: TestEvent.DeferredKey.keyA.rawValue)
    XCTAssertEqual(logged, true)
  }
  
  func testDeferredConstructedEventHasDefaultProperty() {
    Analytics.logDeferred(TestEvent.just)
    let logged: String? = provider.getLoggedDeferredProperty(eventIdx: 0, for: TestEvent.DeferredKey.keyB.rawValue)
    XCTAssertEqual(logged, _someDefaultValue)
  }
  
  func testDeferredConstructedEventUpdatesDefaultProperty() {
    let value = "CBA"
    Analytics.setDeferredProperty(for: TestEvent.just, key: .keyB, value: value)
    Analytics.logDeferred(TestEvent.just)
    let logged: String? = provider.getLoggedDeferredProperty(eventIdx: 0, for: TestEvent.DeferredKey.keyB.rawValue)
    XCTAssertEqual(logged, value)
  }
  
  func testDeferredConstructedEventMixDefaultAndNewProperty() {
    Analytics.setDeferredProperty(for: TestEvent.just, key: .keyA, value: true)
    Analytics.logDeferred(TestEvent.just)
    let loggedNew: Bool? = provider.getLoggedDeferredProperty(eventIdx: 0, for: TestEvent.DeferredKey.keyA.rawValue)
    let loggedDefault: String? = provider.getLoggedDeferredProperty(eventIdx: 0, for: TestEvent.DeferredKey.keyB.rawValue)
    XCTAssertEqual(loggedNew, true)
    XCTAssertEqual(loggedDefault, _someDefaultValue)
  }
  
  func testDeferredConstructedEventCleanAfterLogged() {
    Analytics.setDeferredProperty(for: TestEvent.just, key: .keyA, value: true)
    Analytics.logDeferred(TestEvent.just)
    Analytics.logDeferred(TestEvent.just)
    let logged: Bool? = provider.getLoggedDeferredProperty(eventIdx: 1, for: TestEvent.DeferredKey.keyA.rawValue)
    XCTAssertNil(logged)
  }
  
}

private let _someDefaultValue = "ABC"
private enum TestEvent: AnalyticsEvent, DeferredConstructed {
  
  case just
  
  enum DeferredKey: String {
    case keyA
    case keyB
  }

  var name: String {
    return "test"
  }
  
  var defaultParameters: [DeferredKey: Any] {
    return [.keyB: _someDefaultValue]
  }
  
}
