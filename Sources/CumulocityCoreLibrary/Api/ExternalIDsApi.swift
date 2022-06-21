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

	/// Retrieve all external IDs of a specific managed object
	/// Retrieve all external IDs of a existing managed object (identified by ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_IDENTITY_READ <b>OR</b> owner of the resource <b>OR</b> MANAGED_OBJECT_READ permission on the resource
	/// </section>
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
	public func getExternalIds(id: String) throws -> AnyPublisher<C8yExternalIds, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/identity/globalIds/\(id)/externalIds")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.externalidcollection+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error401)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yExternalIds.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create an external ID
	/// Create an external ID for an existing managed object (identified by ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_IDENTITY_ADMIN <b>OR</b> owner of the resource <b>OR</b> MANAGED_OBJECT_ADMIN permission on the resource
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  An external ID was created.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 409
	///		  Duplicate – Identity already bound to a different Global ID.
	/// - Parameters:
	/// 	- body 
	/// 	- id 
	///		  Unique identifier of the managed object.
	public func createExternalId(body: C8yExternalId, id: String) throws -> AnyPublisher<C8yExternalId, Swift.Error> {
		var requestBody = body
		requestBody.managedObject = nil
		requestBody.`self` = nil
		let builder = URLRequestBuilder()
			.set(resourcePath: "/identity/globalIds/\(id)/externalIds")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.externalid+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.externalid+json")
			.set(httpBody: try JSONEncoder().encode(requestBody))
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error401)
			}
			guard httpResponse.statusCode != 409 else {
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: "Duplicate – Identity already bound to a different Global ID.")
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yExternalId.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific external ID
	/// Retrieve a specific external ID of a particular type.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_IDENTITY_READ <b>OR</b> owner of the resource <b>OR</b> MANAGED_OBJECT_READ permission on the resource
	/// </section>
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
	public func getExternalId(type: String, externalId: String) throws -> AnyPublisher<C8yExternalId, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/identity/externalIds/\(type)/\(externalId)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.externalid+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error401)
			}
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error404)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yExternalId.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove a specific external ID
	/// Remove a specific external ID of a particular type.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_IDENTITY_ADMIN <b>OR</b> owner of the resource <b>OR</b> MANAGED_OBJECT_ADMIN permission on the resource
	/// </section>
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
	public func deleteExternalId(type: String, externalId: String) throws -> AnyPublisher<Data, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/identity/externalIds/\(type)/\(externalId)")
			.set(httpMethod: "delete")
			.add(header: "Accept", value: "application/json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error401)
			}
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error404)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).eraseToAnyPublisher()
	}
}
