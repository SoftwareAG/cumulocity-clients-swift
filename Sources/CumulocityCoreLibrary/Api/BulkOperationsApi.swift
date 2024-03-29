//
// BulkOperationsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// The bulk operations API allows to schedule an operation on a group of devices to be executed at a specified time.It is required to specify the delay between the creation of subsequent operations.When the bulk operation is created, it has the status ACTIVE.When all operations are created, the bulk operation has the status COMPLETED.It is also possible to cancel an already created bulk operation by deleting it.
/// 
/// When you create a bulk operation, you can run it in two modes:
/// 
/// * If `groupId` is passed, it works the standard way, that means, it takes devices from a group and schedules operations on them.
/// * If `failedParentId` is passed, it takes the already processed bulk operation by that ID, and schedules operations on devices for which the previous operations failed.
/// 
/// Note that passing both `groupId` and `failedParentId` will not work, and a bulk operation works with groups of type `static` and `dynamic`.
/// 
/// > **ⓘ Note** The bulk operations API requires different roles than the rest of the device control API: `BULK_OPERATION_READ` and `BULK_OPERATION_ADMIN`.
/// The Accept header should be provided in all POST/PUT requests, otherwise an empty response body will be returned.
public class BulkOperationsApi: AdaptableApi {

	/// Retrieve a list of bulk operations
	/// 
	/// Retrieve a list of bulk operations.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_BULK_OPERATION_READ 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the list of bulk operations sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// 
	/// - Parameters:
	///   - currentPage:
	///     The current page of the paginated results.
	///   - pageSize:
	///     Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	///   - withTotalElements:
	///     When set to `true`, the returned result will contain in the statistics object the total number of elements. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getBulkOperations(currentPage: Int? = nil, pageSize: Int? = nil, withTotalElements: Bool? = nil) -> AnyPublisher<C8yBulkOperationCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/bulkoperations")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.bulkoperationcollection+json, application/vnd.com.nsn.cumulocity.error+json")
			.add(queryItem: "currentPage", value: currentPage)
			.add(queryItem: "pageSize", value: pageSize)
			.add(queryItem: "withTotalElements", value: withTotalElements)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).decode(type: C8yBulkOperationCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create a bulk operation
	/// 
	/// Create a bulk operation.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_BULK_OPERATION_ADMIN 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 A bulk operation was created.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func createBulkOperation(body: C8yBulkOperation, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<C8yBulkOperation, Error> {
		var requestBody = body
		requestBody.generalStatus = nil
		requestBody.`self` = nil
		requestBody.progress = nil
		requestBody.id = nil
		requestBody.status = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yBulkOperation, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/bulkoperations")
			.set(httpMethod: "post")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.bulkoperation+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.bulkoperation+json")
			.set(httpBody: encodedRequestBody)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).decode(type: C8yBulkOperation.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific bulk operation
	/// 
	/// Retrieve a specific bulk operation (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_BULK_OPERATION_READ 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the bulk operation is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Bulk operation not found.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the bulk operation.
	public func getBulkOperation(id: String) -> AnyPublisher<C8yBulkOperation, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/bulkoperations/\(id)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.bulkoperation+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).decode(type: C8yBulkOperation.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update a specific bulk operation
	/// 
	/// Update a specific bulk operation (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_BULK_OPERATION_ADMIN 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 A bulk operation was updated.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Bulk operation not found.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - id:
	///     Unique identifier of the bulk operation.
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func updateBulkOperation(body: C8yBulkOperation, id: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<C8yBulkOperation, Error> {
		var requestBody = body
		requestBody.generalStatus = nil
		requestBody.`self` = nil
		requestBody.progress = nil
		requestBody.id = nil
		requestBody.status = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yBulkOperation, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/bulkoperations/\(id)")
			.set(httpMethod: "put")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.bulkoperation+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.bulkoperation+json")
			.set(httpBody: encodedRequestBody)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).decode(type: C8yBulkOperation.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Delete a specific bulk operation
	/// 
	/// Delete a specific bulk operation (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_BULK_OPERATION_ADMIN 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 A bulk operation was removed.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// * HTTP 404 Bulk operation not found.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the bulk operation.
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func deleteBulkOperation(id: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/bulkoperations/\(id)")
			.set(httpMethod: "delete")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Accept", value: "application/json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).eraseToAnyPublisher()
	}
}
