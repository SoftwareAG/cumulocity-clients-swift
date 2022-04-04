//
// OperationsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// API methods to create, retrieve, update and delete operations in Cumulocity IoT.
/// 
/// > **&#9432; Info:** The Accept header should be provided in all POST/PUT requests, otherwise an empty response body will be returned.
/// 
public class OperationsApi: AdaptableApi {

	/// Retrieve a list of operations
	/// Retrieve a list of operations.
	/// 
	/// Notes about operation collections:
	/// 
	/// * The embedded operation object contains `deviceExternalIDs` only when queried with an `agentId` parameter.
	/// * The embedded operation object is filled with `deviceName`, but only when requesting resource: Get a collection of operations.
	/// * Operations are returned in the order of their ascending IDs.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_DEVICE_CONTROL_READ
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the list of operations is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- agentId 
	///		  An agent ID that may be part of the operation. If this parameter is set, the operation response objects contain the `deviceExternalIDs` object.
	/// 	- deviceId 
	///		  The ID of the device the operation is performed for.
	/// 	- status 
	///		  Status of the operation.
	/// 	- fragmentType 
	///		  The type of fragment that must be part of the operation.
	/// 	- dateFrom 
	///		  Start date or date and time of the operation.
	/// 	- dateTo 
	///		  End date or date and time of the operation.
	/// 	- revert 
	///		  If you are using a range query (that is, at least one of the `dateFrom` or `dateTo` parameters is included in the request), then setting `revert=true` will sort the results by the oldest operations first. By default, the results are sorted by the latest operations first. 
	/// 	- bulkOperationId 
	///		  The bulk operation ID that this operation belongs to.
	/// 	- pageSize 
	///		  Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	/// 	- currentPage 
	///		  The current page of the paginated results.
	/// 	- withTotalPages 
	///		  When set to true, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getOperationCollectionResource(agentId: String? = nil, deviceId: String? = nil, status: String? = nil, fragmentType: String? = nil, dateFrom: String? = nil, dateTo: String? = nil, revert: Bool? = nil, bulkOperationId: String? = nil, pageSize: Int? = nil, currentPage: Int? = nil, withTotalPages: Bool? = nil) throws -> AnyPublisher<C8yOperationCollection, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = agentId { queryItems.append(URLQueryItem(name: "agentId", value: String(parameter)))}
		if let parameter = deviceId { queryItems.append(URLQueryItem(name: "deviceId", value: String(parameter)))}
		if let parameter = status { queryItems.append(URLQueryItem(name: "status", value: String(parameter)))}
		if let parameter = fragmentType { queryItems.append(URLQueryItem(name: "fragmentType", value: String(parameter)))}
		if let parameter = dateFrom { queryItems.append(URLQueryItem(name: "dateFrom", value: String(parameter)))}
		if let parameter = dateTo { queryItems.append(URLQueryItem(name: "dateTo", value: String(parameter)))}
		if let parameter = revert { queryItems.append(URLQueryItem(name: "revert", value: String(parameter)))}
		if let parameter = bulkOperationId { queryItems.append(URLQueryItem(name: "bulkOperationId", value: String(parameter)))}
		if let parameter = pageSize { queryItems.append(URLQueryItem(name: "pageSize", value: String(parameter)))}
		if let parameter = currentPage { queryItems.append(URLQueryItem(name: "currentPage", value: String(parameter)))}
		if let parameter = withTotalPages { queryItems.append(URLQueryItem(name: "withTotalPages", value: String(parameter)))}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/operations")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.operationcollection+json")
			.set(queryItems: queryItems)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yOperationCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create an operation
	/// Create an operation.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_DEVICE_CONTROL_ADMIN <b>OR</b> owner of the device <b>OR</b> ADMIN permissions on the device
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  An operation was created.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- body 
	public func postOperationCollectionResource(body: C8yOperation) throws -> AnyPublisher<C8yOperation, Swift.Error> {
		var requestBody = body
		requestBody.creationTime = nil
		requestBody.deviceExternalIDs = nil
		requestBody.bulkOperationId = nil
		requestBody.failureReason = nil
		requestBody.`self` = nil
		requestBody.id = nil
		requestBody.status = nil
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/operations")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.operation+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.operation+json")
			.set(httpBody: try JSONEncoder().encode(requestBody))
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yOperation.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Delete a list of operations
	/// Delete a list of operations.
	/// 
	/// The DELETE method allows for deletion of operation collections.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_DEVICE_CONTROL_ADMIN
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  A list of operations was removed.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not authorized to perform this operation.
	/// - Parameters:
	/// 	- agentId 
	///		  An agent ID that may be part of the operation.
	/// 	- deviceId 
	///		  The ID of the device the operation is performed for.
	/// 	- status 
	///		  Status of the operation.
	/// 	- dateFrom 
	///		  Start date or date and time of the operation.
	/// 	- dateTo 
	///		  End date or date and time of the operation.
	public func deleteOperationCollectionResource(agentId: String? = nil, deviceId: String? = nil, status: String? = nil, dateFrom: String? = nil, dateTo: String? = nil) throws -> AnyPublisher<Data, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = agentId { queryItems.append(URLQueryItem(name: "agentId", value: String(parameter)))}
		if let parameter = deviceId { queryItems.append(URLQueryItem(name: "deviceId", value: String(parameter)))}
		if let parameter = status { queryItems.append(URLQueryItem(name: "status", value: String(parameter)))}
		if let parameter = dateFrom { queryItems.append(URLQueryItem(name: "dateFrom", value: String(parameter)))}
		if let parameter = dateTo { queryItems.append(URLQueryItem(name: "dateTo", value: String(parameter)))}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/operations")
			.set(httpMethod: "delete")
			.add(header: "Accept", value: "application/json")
			.set(queryItems: queryItems)
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
	
	/// Retrieve a specific operation
	/// Retrieve a specific operation (by a given ID).
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_DEVICE_CONTROL_READ <b>OR</b> owner of the resource <b>OR</b> ADMIN permission on the device
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the operation is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Operation not found.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the operation.
	public func getOperationResource(id: String) throws -> AnyPublisher<C8yOperation, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/operations/\(id)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.operation+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yOperation.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update a specific operation status
	/// 
	/// Update a specific operation (by a given ID).
	/// You can only update its status.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_DEVICE_CONTROL_ADMIN <b>OR</b> owner of the resource <b>OR</b> ADMIN permission on the device
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  An operation was updated.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Operation not found.
	/// 	- 422
	///		  Validation error.
	/// - Parameters:
	/// 	- body 
	/// 	- id 
	///		  Unique identifier of the operation.
	public func putOperationResource(body: C8yOperation, id: String) throws -> AnyPublisher<C8yOperation, Swift.Error> {
		var requestBody = body
		requestBody.creationTime = nil
		requestBody.deviceExternalIDs = nil
		requestBody.comCumulocityModelWebCamDevice = nil
		requestBody.bulkOperationId = nil
		requestBody.failureReason = nil
		requestBody.`self` = nil
		requestBody.id = nil
		requestBody.deviceId = nil
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/operations/\(id)")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.operation+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.operation+json")
			.set(httpBody: try JSONEncoder().encode(requestBody))
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yOperation.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
