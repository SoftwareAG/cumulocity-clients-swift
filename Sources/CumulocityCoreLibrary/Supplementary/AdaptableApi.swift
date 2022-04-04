//
// AdaptableApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public class AdaptableApi {

    let requestBuilder: URLRequestBuilder
    let session: URLSession

	public init(requestBuilder: URLRequestBuilder = URLRequestBuilder(), withSession session: URLSession = URLSession.shared) {
		self.requestBuilder = requestBuilder
 		self.session = session
	}

    /// Allows to modify any property of the passed `URLRequestBuilder`.
    ///
    /// The default implementation merges the  properties  `schema`,` host`, `path`, `queryItems`, `requestHeaders`
    /// of the `requestBuilder` with the passed `URLRequestBuilder`.
    ///
    /// - Parameter builder: `URLRequestBuilder` to modify
    /// - Returns modified builder
    public func adapt(builder: URLRequestBuilder) -> URLRequestBuilder {
        let newBuilder = URLRequestBuilder(with: self.requestBuilder)
        return newBuilder.merge(with: builder)
    }
}
