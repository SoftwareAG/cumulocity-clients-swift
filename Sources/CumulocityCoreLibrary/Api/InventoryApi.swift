//
// InventoryApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// The inventory stores all master data related to devices, their configuration and their connections. It also contains all related assets (for example, vehicles, machines, buildings) and their structure. The inventory API resource returns URIs and URI templates to collections of managed objects.
public class InventoryApi: AdaptableApi {

	/// Retrieve URIs to collections of managed objects
	/// Retrieve URIs and URI templates to collections of managed objects.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_READ
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the URIs are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not authorized to perform this operation.
	public func getInventoryApiResource() throws -> AnyPublisher<C8yInventoryApiResource, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.inventoryapi+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error401)
			}
			guard httpResponse.statusCode != 403 else {
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: "Not authorized to perform this operation.")
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yInventoryApiResource.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
