//
// MeasurementApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// The measurement API resource returns URIs and URI templates to collections of measurements, so that all measurements can be filtered and retrieved. Querying without filters can be slow, hence it is recommended to narrow the scope by using time [range queries](https://en.wikipedia.org/wiki/Range_query_(database)). Moreover, the scope can be significantly reduced by querying by source.
public class MeasurementApi: AdaptableApi {

	public override init() {
		super.init()
	}

	public override init(requestBuilder: URLRequestBuilder) {
		super.init(requestBuilder: requestBuilder)
	}

	/// Retrieve URIs to collections of measurements
	/// Retrieve URIs and URI templates to collections of measurements.
	/// 
	/// > **&#9432; Info:** The response sample on the right side contains a subset of all URIs returned by the endpoint method. For all available query parameters see [Retrieve all measurements](#operation/getMeasurementCollectionResource).
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the URIs are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not authorized to perform this operation.
	public func getMeasurementApiResource() throws -> AnyPublisher<C8yMeasurementApiResource, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/measurement")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.measurementApi+json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yMeasurementApiResource.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
