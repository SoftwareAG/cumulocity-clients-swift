//
// PlatformApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// To discover the URIs of the various interfaces of Cumulocity IoT, a platform interface is provided. This interface aggregates all the underlying API resources.
public class PlatformApi: AdaptableApi {

	public override init() {
		super.init()
	}

	public override init(requestBuilder: URLRequestBuilder) {
		super.init(requestBuilder: requestBuilder)
	}

	/// Retrieve URIs to collection of platform objects
	/// Retrieve URIs and URI templates to collections of platform objects.
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the URIs are sent in the response.
	public func getPlatformApiResource() throws -> AnyPublisher<C8yPlatformApiResource, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/platform")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.platformapi+json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yPlatformApiResource.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
