//
//  Pipe.swift
//  
//
//  Created by Nikolay Fiantsev on 29.10.2021.
//

import Foundation

precedencegroup CompositionPrecedence {
    associativity: left
}

infix operator |> : CompositionPrecedence

func |> <A, B, C>(f: @escaping (A)->B, g: @escaping (B)->C) -> (A)->C {
  return { a -> C in
    g(f(a))
  }
}
