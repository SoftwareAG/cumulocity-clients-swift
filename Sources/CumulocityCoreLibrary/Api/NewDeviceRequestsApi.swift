//
// NewDeviceRequestsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// API methods to create, retrieve, update and delete new device requests in Cumulocity IoT.
/// 
/// > **ⓘ Note** The Accept header should be provided in all POST/PUT requests, otherwise an empty response body will be returned.
public class NewDeviceRequestsApi: AdaptableApi {

	/// Retrieve a list of new device requests
	/// 
	/// Retrieve a list of new device requests.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_DEVICE_CONTROL_READ 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the list of new device requests sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// 
	/// - Parameters:
	///   - currentPage:
	///     The current page of the paginated results.
	///   - pageSize:
	///     Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	///   - withTotalElements:
	///     When set to `true`, the returned result will contain in the statistics object the total number of elements. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	///   - withTotalPages:
	///     When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getNewDeviceRequests(currentPage: Int? = nil, pageSize: Int? = nil, withTotalElements: Bool? = nil, withTotalPages: Bool? = nil) -> AnyPublisher<C8yNewDeviceRequestCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/newDeviceRequests")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.newdevicerequestcollection+json")
			.add(queryItem: "currentPage", value: currentPage)
			.add(queryItem: "pageSize", value: pageSize)
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
		}).decode(type: C8yNewDeviceRequestCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create a new device request
	/// 
	/// Create a new device request.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_DEVICE_CONTROL_ADMIN 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 A new device request was created.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 422 Unprocessable Entity – invalid payload.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func createNewDeviceRequest(body: C8yNewDeviceRequest, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<C8yNewDeviceRequest, Error> {
		var requestBody = body
		requestBody.`self` = nil
		requestBody.status = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yNewDeviceRequest, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/newDeviceRequests")
			.set(httpMethod: "post")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.newdevicerequest+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.newdevicerequest+json, application/vnd.com.nsn.cumulocity.error+json")
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
		}).decode(type: C8yNewDeviceRequest.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific new device request
	/// 
	/// Retrieve a specific new device request (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_DEVICE_CONTROL_READ 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the new device request is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 New device request not found.
	/// 
	/// - Parameters:
	///   - requestId:
	///     Unique identifier of the new device request.
	public func getNewDeviceRequest(requestId: String) -> AnyPublisher<C8yNewDeviceRequest, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/newDeviceRequests/\(requestId)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.newdevicerequest+json, application/vnd.com.nsn.cumulocity.error+json")
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
		}).decode(type: C8yNewDeviceRequest.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update a specific new device request status
	/// 
	/// Update a specific new device request (by a given ID).You can only update its status.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_DEVICE_CONTROL_ADMIN 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 A new device request was updated.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 New device request not found.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - requestId:
	///     Unique identifier of the new device request.
	public func updateNewDeviceRequest(body: C8yNewDeviceRequest, requestId: String) -> AnyPublisher<C8yNewDeviceRequest, Error> {
		var requestBody = body
		requestBody.`self` = nil
		requestBody.id = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yNewDeviceRequest, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/newDeviceRequests/\(requestId)")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.newdevicerequest+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.newdevicerequest+json, application/vnd.com.nsn.cumulocity.error+json")
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
		}).decode(type: C8yNewDeviceRequest.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Delete a specific new device request
	/// 
	/// Delete a specific new device request (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_ADMIN 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 A new device request was removed.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// * HTTP 404 New device request not found.
	/// 
	/// - Parameters:
	///   - requestId:
	///     Unique identifier of the new device request.
	public func deleteNewDeviceRequest(requestId: String) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/newDeviceRequests/\(requestId)")
			.set(httpMethod: "delete")
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
