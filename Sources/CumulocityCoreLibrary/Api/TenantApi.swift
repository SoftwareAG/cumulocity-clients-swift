//
// TenantApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// The tenant API resource returns URIs and URI templates to collections of tenants, so that all tenants can be filtered and retrieved.
public class TenantApi: AdaptableApi {

	/// Retrieve URIs to collections of tenants
	/// Retrieve URIs and URI templates to collections of tenants and options.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_TENANT_MANAGEMENT_READ
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the URIs are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	public func getTenantsApiResource() throws -> AnyPublisher<C8yTenantApiResource, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.tenantapi+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yTenantApiResource.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
