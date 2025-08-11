//
//  InjectedValues.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 11/08/2025.
//
import Foundation

public class Resolver {
    
    // MARK: - Static properties
    
    internal static let shared = Resolver()
    internal static var lock = NSRecursiveLock()
    
    /// A list of resolved dependencies
    public static var registeredDependencies: [String: AnyObject]? { return Resolver.shared.dependencies }
    
    // MARK: - Properties
    
    internal var dependencies = [String: AnyObject]()
    
    // MARK: - Static functions

    /**
     Register the dependecy
     - Parameter dependency: The dependency to register
     */
    public static func register<T>(_ dependency: T) {
        shared.register(dependency)
    }

    /**
     Resolve the dependency
     */
    public static func resolve<T>() -> T {
        shared.resolve()
    }

    private func register<T>(_ dependency: T) {
        let key = "\(T.self)"
        dependencies[key] = dependency as AnyObject
    }

    private func resolve<T>() -> T {
        let key = "\(T.self)"
        let dependency = dependencies[key] as? T
        
        if dependency == nil {
            fatalError("Dependecy was not found, make sure to register \(type(of: T.self)) for key: \(key)")
        }
        
        return dependency!
    }
}

@propertyWrapper
public struct Injected<T> {
    
    // MARK: - Properties
    
    public var wrappedValue: T

    // MARK: - Initliazers
    
    public init() {
        self.wrappedValue = Resolver.resolve()
    }
}
