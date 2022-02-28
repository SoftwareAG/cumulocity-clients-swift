//
// ExternalIDsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// The external ID resource represents an individual external ID that can be queried and deleted.
/// 
/// > **&#9432; Info:** The Accept header should be provided in all POST requests, otherwise an empty response body will be returned.
/// 
public class ExternalIDsApi: AdaptableApi {

	public override init() {
		super.init()
	}

	public override init(requestBuilder: URLRequestBuilder) {
		super.init(requestBuilder: requestBuilder)
	}

	/// Retrieve all external IDs of a specific managed object
	/// Retrieve all external IDs of a existing managed object (identified by ID).
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_IDENTITY_READ <b>OR</b> owner of the resource <b>OR</b> MANAGED_OBJECT_READ permission on the resource
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and all the external IDs are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the managed object.
	public func getExternalIDCollectionResource(id: String) throws -> AnyPublisher<C8yExternalIDCollection, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/identity/globalIds/\(id)/externalIds")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.externalidcollection+json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yExternalIDCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create an external ID
	/// Create an external ID for an existing managed object (identified by ID).
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_IDENTITY_ADMIN <b>OR</b> owner of the resource <b>OR</b> MANAGED_OBJECT_ADMIN permission on the resource
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  An external ID was created.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- body 
	/// 	- id 
	///		  Unique identifier of the managed object.
	public func postExternalIDCollectionResource(body: C8yExternalId, id: String) throws -> AnyPublisher<C8yExternalId, Swift.Error> {
		var requestBody = body
		requestBody.managedObject = nil
		requestBody.`self` = nil
		let builder = URLRequestBuilder()
			.set(resourcePath: "/identity/globalIds/\(id)/externalIds")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.externalid+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.externalid+json")
			.set(httpBody: try JSONEncoder().encode(requestBody))
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yExternalId.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific external ID
	/// Retrieve a specific external ID of a particular type.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_IDENTITY_READ <b>OR</b> owner of the resource <b>OR</b> MANAGED_OBJECT_READ permission on the resource
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the external ID is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  External ID not found.
	/// - Parameters:
	/// 	- type 
	///		  The identifier used in the external system that Cumulocity IoT interfaces with.
	/// 	- externalId 
	///		  The type of the external identifier.
	public func getExternalIDResource(type: String, externalId: String) throws -> AnyPublisher<C8yExternalId, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/identity/externalIds/\(type)/\(externalId)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.externalid+json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yExternalId.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove a specific external ID
	/// Remove a specific external ID of a particular type.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_IDENTITY_ADMIN <b>OR</b> owner of the resource <b>OR</b> MANAGED_OBJECT_ADMIN permission on the resource
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  An external ID was deleted.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  External ID not found.
	/// - Parameters:
	/// 	- type 
	///		  The identifier used in the external system that Cumulocity IoT interfaces with.
	/// 	- externalId 
	///		  The type of the external identifier.
	public func deleteExternalIDResource(type: String, externalId: String) throws -> AnyPublisher<Data, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/identity/externalIds/\(type)/\(externalId)")
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
