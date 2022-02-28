//
// ApplicationApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// The application API resource returns URIs and URI templates to collections of applications so that all applications with a particular name and all applications owned by particular tenant can be queried.
public class ApplicationApi: AdaptableApi {

	public override init() {
		super.init()
	}

	public override init(requestBuilder: URLRequestBuilder) {
		super.init(requestBuilder: requestBuilder)
	}

	/// Retrieve URIs to collections of applications
	/// Retrieve URIs and URI templates to collections of applications.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_APPLICATION_MANAGEMENT_READ
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and and the URIs are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	public func getApplicationManagementApiResource() throws -> AnyPublisher<C8yApplicationApiResource, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.applicationapi+json, application/vnd.com.nsn.cumulocity.error+json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yApplicationApiResource.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve applications by name
	/// Retrieve applications by name.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_APPLICATION_MANAGEMENT_READ
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the applications are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- name 
	///		  The name of the application.
	public func getApplicationsByNameCollectionResource(name: String) throws -> AnyPublisher<C8yApplicationCollection, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applicationsByName/\(name)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.applicationcollection+json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yApplicationCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve applications by tenant
	/// Retrieve applications subscribed or owned by a particular tenant (by a given tenant ID).
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_APPLICATION_MANAGEMENT_READ
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the applications are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	public func getApplicationsByTenantCollectionResource(tenantId: String) throws -> AnyPublisher<C8yApplicationCollection, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applicationsByTenant/\(tenantId)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.applicationcollection+json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yApplicationCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve applications by owner
	/// Retrieve all applications owned by a particular tenant (by a given tenant ID).
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_APPLICATION_MANAGEMENT_READ
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the applications are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	public func getApplicationsByOwnerCollectionResource(tenantId: String) throws -> AnyPublisher<C8yApplicationCollection, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applicationsByOwner/\(tenantId)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.applicationcollection+json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yApplicationCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve applications by user
	/// Retrieve all applications for a particular user (by a given username).
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_APPLICATION_MANAGEMENT_READ
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the applications are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- username 
	///		  The username of the a user.
	public func getApplicationsByUserCollectionResource(username: String) throws -> AnyPublisher<C8yApplicationCollection, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applicationsByUser/\(username)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.applicationcollection+json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yApplicationCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
