//
// BootstrapUserApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// API methods to retrieve the bootstrap user of an application.
public class BootstrapUserApi: AdaptableApi {

	/// Retrieve the bootstrap user for a specific application
	/// Retrieve the bootstrap user for a specific application (by a given ID).
	/// 
	/// This only works for microservice applications.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_APPLICATION_MANAGEMENT_ADMIN
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the bootstrap user of the application is sent in the response.
	/// 	- 400
	///		  Bad request.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the application.
	public func getBootstrapUser(id: String) throws -> AnyPublisher<C8yBootstrapUser, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applications/\(id)/bootstrapUser")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.user+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yBootstrapUser.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
