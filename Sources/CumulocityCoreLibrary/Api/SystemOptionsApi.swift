//
// SystemOptionsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// API methods to retrieve the read-only properties predefined in the platform's configuration.
public class SystemOptionsApi: AdaptableApi {

	/// Retrieve all system options
	/// Retrieve all the system options available on the tenant.
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the system options are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	public func getSystemOptions() -> AnyPublisher<C8ySystemOptionCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/system/options")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.optioncollection+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					throw Errors.badResponseError(response: httpResponse, reason: c8yError)
				}
				throw Errors.undescribedError(response: httpResponse)
			}
			return element.data
		}).decode(type: C8ySystemOptionCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific system option
	/// Retrieve a specific system option (by a given category and key) on your tenant.
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the system option is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- category 
	///		  The category of the system options.
	/// 	- key 
	///		  The key of a system option.
	public func getSystemOption(category: String, key: String) -> AnyPublisher<C8ySystemOption, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/system/options/\(category)/\(key)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.option+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					throw Errors.badResponseError(response: httpResponse, reason: c8yError)
				}
				throw Errors.undescribedError(response: httpResponse)
			}
			return element.data
		}).decode(type: C8ySystemOption.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
