//
// NewDeviceRequestsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// API methods to create, retrieve, update and delete new device requests in Cumulocity IoT.
/// 
/// > **&#9432; Info:** The Accept header should be provided in all POST/PUT requests, otherwise an empty response body will be returned.
/// 
public class NewDeviceRequestsApi: AdaptableApi {

	/// Retrieve a list of new device requests
	/// Retrieve a list of new device requests.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_DEVICE_CONTROL_READ
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the list of new device requests sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	public func getNewDeviceRequestCollectionResource() throws -> AnyPublisher<C8yNewDeviceRequestCollection, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/newDeviceRequests")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.newdevicerequestcollection+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yNewDeviceRequestCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create a new device request
	/// Create a new device request.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_DEVICE_CONTROL_ADMIN
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  A new device request was created.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- body 
	public func postNewDeviceRequestCollectionResource(body: C8yNewDeviceRequest) throws -> AnyPublisher<C8yNewDeviceRequest, Swift.Error> {
		var requestBody = body
		requestBody.`self` = nil
		requestBody.status = nil
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/newDeviceRequests")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.newdevicerequest+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.newdevicerequest+json, application/vnd.com.nsn.cumulocity.error+json")
			.set(httpBody: try JSONEncoder().encode(requestBody))
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yNewDeviceRequest.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific new device request
	/// Retrieve a specific new device request (by a given ID).
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_DEVICE_CONTROL_READ
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the new device request is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  New device request not found.
	/// - Parameters:
	/// 	- requestId 
	///		  Unique identifier of the new device request.
	public func getNewDeviceRequestResource(requestId: String) throws -> AnyPublisher<C8yNewDeviceRequest, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/newDeviceRequests/\(requestId)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.newdevicerequest+json, application/vnd.com.nsn.cumulocity.error+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yNewDeviceRequest.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update a specific new device request status
	/// 
	/// Update a specific new device request (by a given ID).
	/// You can only update its status.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_DEVICE_CONTROL_ADMIN
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  A new device request was updated.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  New device request not found.
	/// - Parameters:
	/// 	- body 
	/// 	- requestId 
	///		  Unique identifier of the new device request.
	public func putNewDeviceRequestResource(body: C8yNewDeviceRequest, requestId: String) throws -> AnyPublisher<C8yNewDeviceRequest, Swift.Error> {
		var requestBody = body
		requestBody.`self` = nil
		requestBody.id = nil
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/newDeviceRequests/\(requestId)")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.newdevicerequest+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.newdevicerequest+json, application/vnd.com.nsn.cumulocity.error+json")
			.set(httpBody: try JSONEncoder().encode(requestBody))
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yNewDeviceRequest.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Delete a specific new device request
	/// Delete a specific new device request (by a given ID).
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_USER_MANAGEMENT_ADMIN
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  A new device request was removed.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not authorized to perform this operation.
	/// 	- 404
	///		  New device request not found.
	/// - Parameters:
	/// 	- requestId 
	///		  Unique identifier of the new device request.
	public func deleteNewDeviceRequestResource(requestId: String) throws -> AnyPublisher<Data, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/newDeviceRequests/\(requestId)")
			.set(httpMethod: "delete")
			.add(header: "Accept", value: "application/json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
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
