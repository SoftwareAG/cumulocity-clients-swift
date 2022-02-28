//
// BulkOperationsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// The bulk operations API allows to schedule an operation on a group of devices to be executed at a specified time.
/// It is required to specify the delay between the creation of subsequent operations.
/// When the bulk operation is created, it has the status ACTIVE.
/// When all operations are created, the bulk operation has the status COMPLETED.
/// It is also possible to cancel an already created bulk operation by deleting it.
/// 
/// When you create a bulk operation, you can run it in two modes:
/// 
/// * If `groupId` is passed, it works the standard way, i.e. it takes devices from a group and schedules operations on them.
/// * If `failedParentId` is passed, it takes the already processed bulk operation by that ID, and schedules operations on devices for which the previous operations failed.
/// 
/// Note that passing both `groupId` and `failedParentId` will not work, and a bulk operation works with groups of type `static` and `dynamic`.
/// 
/// > **&#9432; Info:** The bulk operations API requires different roles than the rest of the device control API: `BULK_OPERATION_READ` and `BULK_OPERATION_ADMIN`.
/// > 
/// > The Accept header should be provided in all POST/PUT requests, otherwise an empty response body will be returned.
/// 
public class BulkOperationsApi: AdaptableApi {

	public override init() {
		super.init()
	}

	public override init(requestBuilder: URLRequestBuilder) {
		super.init(requestBuilder: requestBuilder)
	}

	/// Retrieve a list of bulk operations
	/// Retrieve a list of bulk operations.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_BULK_OPERATION_READ
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the list of bulk operations sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	public func getBulkOperationCollectionResource() throws -> AnyPublisher<C8yBulkOperationCollection, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/bulkoperations")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.bulkoperationcollection+json, application/vnd.com.nsn.cumulocity.error+json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yBulkOperationCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create a bulk operation
	/// Create a bulk operation.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_BULK_OPERATION_ADMIN
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  A bulk operation was created.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- body 
	public func postBulkOperationCollectionResource(body: C8yBulkOperation) throws -> AnyPublisher<C8yBulkOperation, Swift.Error> {
		var requestBody = body
		requestBody.generalStatus = nil
		requestBody.failedParentId = nil
		requestBody.`self` = nil
		requestBody.progress = nil
		requestBody.id = nil
		requestBody.status = nil
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/bulkoperations")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.bulkoperation+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.bulkoperation+json")
			.set(httpBody: try JSONEncoder().encode(requestBody))
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yBulkOperation.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific bulk operation
	/// Retrieve a specific bulk operation (by a given ID).
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_BULK_OPERATION_READ
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the bulk operation is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Bulk operation not found.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the bulk operation.
	public func getBulkOperationResource(id: String) throws -> AnyPublisher<C8yBulkOperation, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/bulkoperations/\(id)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.bulkoperation+json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yBulkOperation.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update a specific bulk operation
	/// 
	/// Update a specific bulk operation (by a given ID).
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_BULK_OPERATION_ADMIN
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  A bulk operation was updated.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Bulk operation not found.
	/// - Parameters:
	/// 	- body 
	/// 	- id 
	///		  Unique identifier of the bulk operation.
	public func putBulkOperationResource(body: C8yBulkOperation, id: String) throws -> AnyPublisher<C8yBulkOperation, Swift.Error> {
		var requestBody = body
		requestBody.generalStatus = nil
		requestBody.failedParentId = nil
		requestBody.groupId = nil
		requestBody.`self` = nil
		requestBody.operationPrototype = nil
		requestBody.progress = nil
		requestBody.id = nil
		requestBody.startDate = nil
		requestBody.status = nil
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/bulkoperations/\(id)")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.bulkoperation+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.bulkoperation+json")
			.set(httpBody: try JSONEncoder().encode(requestBody))
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yBulkOperation.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Delete a specific bulk operation
	/// Delete a specific bulk operation (by a given ID).
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_BULK_OPERATION_ADMIN
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  A bulk operation was removed.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not authorized to perform this operation.
	/// 	- 404
	///		  Bulk operation not found.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the bulk operation.
	public func deleteBulkOperationResource(id: String) throws -> AnyPublisher<Data, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/bulkoperations/\(id)")
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
