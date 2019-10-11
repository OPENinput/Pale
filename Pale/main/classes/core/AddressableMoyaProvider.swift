//
//  AddressableMoyaProvider.swift
//  Pale
//
//  Created by Jose Gonzalez on 11/10/2019.
//  Copyright © 2019 OPEN input. All rights reserved.
//

import Foundation
import Moya


public protocol Addressable {
    var baseURL: URL { get set }
}


public protocol AddressableMoyaProviderType: Addressable, MoyaProviderType where Target == AddressableTarget<RelativeTarget> {
    associatedtype RelativeTarget: RelativeTargetType

    func request(_ target: RelativeTarget, callbackQueue: DispatchQueue?, progress: Moya.ProgressBlock?, completion: @escaping Moya.Completion) -> Cancellable
}


/// Addressable request provider class. Provides support for dynamic base URLs + relative targets.
public class AddressableMoyaProvider<RelativeTarget: RelativeTargetType>: MoyaProvider<AddressableTarget<RelativeTarget>>, AddressableMoyaProviderType {
    public var baseURL: URL

    public init(baseURL: URL,
         endpointClosure: @escaping EndpointClosure = AddressableMoyaProvider.defaultEndpointMapping,
         requestClosure: @escaping RequestClosure = AddressableMoyaProvider.defaultRequestMapping,
         stubClosure: @escaping StubClosure = AddressableMoyaProvider.neverStub,
         callbackQueue: DispatchQueue? = nil,
         session: Session = MoyaProvider<Target>.defaultAlamofireSession(),
         plugins: [PluginType] = [],
         trackInflights: Bool = false) {

        self.baseURL = baseURL
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, callbackQueue: callbackQueue, session: session, plugins: plugins, trackInflights: trackInflights)
    }

    public func request(_ target: RelativeTarget, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping Completion) -> Cancellable {
        return self.request(AddressableTarget(baseURL: baseURL, relativeTarget: target), callbackQueue: callbackQueue, progress: progress, completion: completion)
    }
}
