//
//  EnrichedAnalyticsEvent.swift
//  
//
//  Created by Nikolay Fiantsev on 23.10.2021.
//

import Foundation

struct EnrichedAnalyticsEvent: AnalyticsEvent {
  let name: String
  let properties: AnalyticsEventProperties?
  let logEventOnce: Bool
}
