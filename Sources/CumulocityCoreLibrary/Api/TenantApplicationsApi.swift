//
// TenantApplicationsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// References to the tenant subscribed applications.
public class TenantApplicationsApi: AdaptableApi {

	public override init() {
		super.init()
	}

	public override init(requestBuilder: URLRequestBuilder) {
		super.init(requestBuilder: requestBuilder)
	}

	/// Retrieve subscribed applications
	/// Retrieve the tenant subscribed applications by a given tenant ID.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// (ROLE_TENANT_MANAGEMENT_READ <b>OR</b> ROLE_TENANT_ADMIN) <b>AND</b> (the current tenant is its parent <b>OR</b> is the management tenant)
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the tenant applications are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not authorized to perform this operation.
	/// 	- 404
	///		  Tenant not found.
	/// - Parameters:
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	/// 	- currentPage 
	///		  The current page of the paginated results.
	/// 	- pageSize 
	///		  Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	/// 	- withTotalPages 
	///		  When set to true, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getTenantApplicationReferenceCollectionResource(tenantId: String, currentPage: Int? = nil, pageSize: Int? = nil, withTotalPages: Bool? = nil) throws -> AnyPublisher<C8yApplicationReferenceCollection, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = currentPage { queryItems.append(URLQueryItem(name: "currentPage", value: String(parameter)))}
		if let parameter = pageSize { queryItems.append(URLQueryItem(name: "pageSize", value: String(parameter)))}
		if let parameter = withTotalPages { queryItems.append(URLQueryItem(name: "withTotalPages", value: String(parameter)))}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/tenants/\(tenantId)/applications")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.applicationreferencecollection+json")
			.set(queryItems: queryItems)
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yApplicationReferenceCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Subscribe to an application
	/// Subscribe a tenant (by a given ID) to an application.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// (ROLE_APPLICATION_MANAGEMENT_ADMIN <b>AND</b> is the application owner <b>AND</b> is the current tenant) <b>OR</b> ((ROLE_TENANT_MANAGEMENT_ADMIN <b>OR</b> ROLE_TENANT_MANAGEMENT_UPDATE) <b>AND</b> (the current tenant is its parent <b>OR</b> is the management tenant))
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  A tenant was subscribed to an application.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Tenant not found.
	/// - Parameters:
	/// 	- body 
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	public func postTenantApplicationReferenceCollectionResource(body: C8ySubscribedApplication, tenantId: String) throws -> AnyPublisher<C8yApplication, Swift.Error> {
		let requestBody = body
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/tenants/\(tenantId)/applications")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.applicationreference+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.application+json")
			.set(httpBody: try JSONEncoder().encode(requestBody))
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yApplication.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Unsubscribe from an application
	/// Unsubscribe a tenant (by a given tenant ID) from an application (by a given application ID).
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// (ROLE_APPLICATION_MANAGEMENT_ADMIN <b>AND</b> is the application owner <b>AND</b> is the current tenant) <b>OR</b> ((ROLE_TENANT_MANAGEMENT_ADMIN <b>OR</b> ROLE_TENANT_MANAGEMENT_UPDATE) <b>AND</b> (the current tenant is its parent <b>OR</b> is the management tenant))
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  A tenant was unsubscribed from an application.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Tenant not found.
	/// - Parameters:
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	/// 	- applicationId 
	///		  Unique identifier of the application.
	public func deleteTenantApplicationReferenceResource(tenantId: String, applicationId: String) throws -> AnyPublisher<Data, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/tenants/\(tenantId)/applications/\(applicationId)")
			.set(httpMethod: "delete")
			.add(header: "Accept", value: "application/json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).eraseToAnyPublisher()
	}
}
