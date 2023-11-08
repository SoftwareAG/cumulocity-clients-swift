//
// OperationsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// API methods to create, retrieve, update and delete operations in Cumulocity IoT.
/// 
/// > **ⓘ Note** The Accept header should be provided in all POST/PUT requests, otherwise an empty response body will be returned.
public class OperationsApi: AdaptableApi {

	/// Retrieve a list of operations
	/// 
	/// Retrieve a list of operations.
	/// 
	/// Notes about operation collections:
	/// 
	/// * The embedded operation object contains `deviceExternalIDs` only when queried with an `agentId` parameter.
	/// * The embedded operation object is filled with `deviceName`, but only when requesting resource: Get a collection of operations.
	/// * Operations are returned in the order of their ascending IDs.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_DEVICE_CONTROL_READ 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the list of operations is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// 
	/// - Parameters:
	///   - agentId:
	///     An agent ID that may be part of the operation. If this parameter is set, the operation response objects contain the `deviceExternalIDs` object.
	///   - bulkOperationId:
	///     The bulk operation ID that this operation belongs to.
	///   - currentPage:
	///     The current page of the paginated results.
	///   - dateFrom:
	///     Start date or date and time of the operation.
	///   - dateTo:
	///     End date or date and time of the operation.
	///   - deviceId:
	///     The ID of the device the operation is performed for.
	///   - fragmentType:
	///     The type of fragment that must be part of the operation.
	///   - pageSize:
	///     Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	///   - revert:
	///     If you are using a range query (that is, at least one of the `dateFrom` or `dateTo` parameters is included in the request), then setting `revert=true` will sort the results by the newest operations first.By default, the results are sorted by the oldest operations first.
	///   - status:
	///     Status of the operation.
	///   - withTotalElements:
	///     When set to `true`, the returned result will contain in the statistics object the total number of elements. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	///   - withTotalPages:
	///     When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getOperations(agentId: String? = nil, bulkOperationId: String? = nil, currentPage: Int? = nil, dateFrom: String? = nil, dateTo: String? = nil, deviceId: String? = nil, fragmentType: String? = nil, pageSize: Int? = nil, revert: Bool? = nil, status: String? = nil, withTotalElements: Bool? = nil, withTotalPages: Bool? = nil) -> AnyPublisher<C8yOperationCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/operations")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.operationcollection+json")
			.add(queryItem: "agentId", value: agentId)
			.add(queryItem: "bulkOperationId", value: bulkOperationId)
			.add(queryItem: "currentPage", value: currentPage)
			.add(queryItem: "dateFrom", value: dateFrom)
			.add(queryItem: "dateTo", value: dateTo)
			.add(queryItem: "deviceId", value: deviceId)
			.add(queryItem: "fragmentType", value: fragmentType)
			.add(queryItem: "pageSize", value: pageSize)
			.add(queryItem: "revert", value: revert)
			.add(queryItem: "status", value: status)
			.add(queryItem: "withTotalElements", value: withTotalElements)
			.add(queryItem: "withTotalPages", value: withTotalPages)
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
		}).decode(type: C8yOperationCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create an operation
	/// 
	/// Create an operation.
	/// 
	/// It is possible to add custom fragments to operations, for example `com_cumulocity_model_WebCamDevice` is a custom object of the webcam operation.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_DEVICE_CONTROL_ADMIN *OR* owner of the device *OR* ADMIN permissions on the device 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 An operation was created.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 422 Unprocessable Entity – invalid payload.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func createOperation(body: C8yOperation, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<C8yOperation, Error> {
		var requestBody = body
		requestBody.creationTime = nil
		requestBody.deviceExternalIDs?.`self` = nil
		requestBody.bulkOperationId = nil
		requestBody.failureReason = nil
		requestBody.`self` = nil
		requestBody.id = nil
		requestBody.status = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yOperation, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/operations")
			.set(httpMethod: "post")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.operation+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.operation+json")
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
		}).decode(type: C8yOperation.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Delete a list of operations
	/// 
	/// Delete a list of operations.
	/// 
	/// The DELETE method allows for deletion of operation collections.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_DEVICE_CONTROL_ADMIN 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 A list of operations was removed.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// 
	/// - Parameters:
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	///   - agentId:
	///     An agent ID that may be part of the operation.
	///   - dateFrom:
	///     Start date or date and time of the operation.
	///   - dateTo:
	///     End date or date and time of the operation.
	///   - deviceId:
	///     The ID of the device the operation is performed for.
	///   - status:
	///     Status of the operation.
	public func deleteOperations(xCumulocityProcessingMode: String? = nil, agentId: String? = nil, dateFrom: String? = nil, dateTo: String? = nil, deviceId: String? = nil, status: String? = nil) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/operations")
			.set(httpMethod: "delete")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Accept", value: "application/json")
			.add(queryItem: "agentId", value: agentId)
			.add(queryItem: "dateFrom", value: dateFrom)
			.add(queryItem: "dateTo", value: dateTo)
			.add(queryItem: "deviceId", value: deviceId)
			.add(queryItem: "status", value: status)
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
	
	/// Retrieve a specific operation
	/// 
	/// Retrieve a specific operation (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_DEVICE_CONTROL_READ *OR* owner of the resource *OR* ADMIN permission on the device 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the operation is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Operation not found.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the operation.
	public func getOperation(id: String) -> AnyPublisher<C8yOperation, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/operations/\(id)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.operation+json")
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
		}).decode(type: C8yOperation.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update a specific operation status
	/// 
	/// Update a specific operation (by a given ID).You can only update its status.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_DEVICE_CONTROL_ADMIN *OR* owner of the resource *OR* ADMIN permission on the device 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 An operation was updated.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Operation not found.
	/// * HTTP 422 Validation error.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - id:
	///     Unique identifier of the operation.
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func updateOperation(body: C8yOperation, id: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<C8yOperation, Error> {
		var requestBody = body
		requestBody.creationTime = nil
		requestBody.deviceExternalIDs?.`self` = nil
		requestBody.bulkOperationId = nil
		requestBody.`self` = nil
		requestBody.id = nil
		requestBody.deviceId = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yOperation, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/operations/\(id)")
			.set(httpMethod: "put")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.operation+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.operation+json")
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
		}).decode(type: C8yOperation.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
