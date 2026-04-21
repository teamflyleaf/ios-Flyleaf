//
//  DIContainer.swift
//  DIContainer
//
//  Created by 여성일 on 4/16/26.
//

public final class DIContainer {
  private var factories: [ObjectIdentifier: () -> Any] = [:]
  private var singletons: [ObjectIdentifier: Any] = [:]
  private var scopes: [ObjectIdentifier: Scope] = [:]
  
  public init() { }
  
  public func register<T>(
    _ type: T.Type,
    scope: Scope = .singleton,
    factory: @escaping () -> T
  ) {
    let key = ObjectIdentifier(type)
    factories[key] = factory
    scopes[key] = scope
  }
  
  public func resolve<T>(_ type: T.Type) -> T? {
    let key = ObjectIdentifier(type)
    guard let factory = factories[key] else { return nil }
    
    switch scopes[key] ?? .singleton {
    case .singleton:
      if let cached = singletons[key] as? T {
        return cached
      }
      guard let instance = factory() as? T else { return nil }
      singletons[key] = instance
      return instance
      
    case .transient:
      return factory() as? T
    }
  }
}
