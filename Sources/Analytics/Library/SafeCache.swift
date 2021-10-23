//
//  SafeCache.swift
//  
//
//  Created by Nikolay Fiantsev on 23.10.2021.
//

import Foundation

final class SafeCache<K: Hashable, V> {
  private var _cache: [K: V] = [:]
  private let _cacheQueue: DispatchQueue
  
  init() {
    self._cacheQueue = DispatchQueue(label: String(describing: Analytics.self), qos: .userInitiated, attributes: .concurrent)
  }
  
  subscript(_ key: K) -> V? {
    get {
      return _get(for: key)
    }
    set {
      _put(newValue, for: key)
    }
  }
  
  private func _put(_ value: V?, for key: K) {
    _cacheQueue.async(flags: .barrier) { [weak self] in
      self?._cache[key] = value
    }
  }
  
  private func _get(for key: K) -> V? {
    _cacheQueue.sync {
      return _cache[key]
    }
  }
    
}
