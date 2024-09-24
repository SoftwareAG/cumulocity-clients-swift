//
// DevicePermissionsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// API methods to retrieve and update device permissions assignments.
/// 
/// Device permissions enable users to access and manipulate devices.
/// 
/// The device permission structure is **[API:fragment_name:permission]** where:
/// 
/// * **API** is one of the following values: OPERATION, ALARM, AUDIT, EVENT, MANAGED_OBJECT, MEASUREMENT or "*"
/// * **fragment_name** can be the name of any fragment, for example, "c8y_Restart" or "*"
/// * **permission** is ADMIN, READ or "*"
/// 
/// Required permission per HTTP method:
/// 
/// * GET - READ or "*"
/// * PUT - ADMIN or "*"
/// 
/// The wildcard "*" enables you to access every API and stored object regardless of the fragments that are inside it.
/// 
/// > **������ Important:** If there is no fragment in an object, for example, to read the object, you must use the wildcard "*" for the **fragment_name** part of the device permission (see the structure above). For example: `"10200":["MEASUREMENT:*:READ"]`.
public class DevicePermissionsApi: AdaptableApi {

	/// Returns all device permissions assignments
	/// 
	/// Returns all device permissions assignments if the current user has READ permission.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_READ *OR* ROLE_USER_MANAGEMENT_CREATE 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the device permissions assignments are sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the managed object.
	public func getDevicePermissionAssignments(id: String) -> AnyPublisher<C8yDevicePermissionOwners, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/devicePermissions/\(id)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/json")
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
		}).decode(type: C8yDevicePermissionOwners.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Updates the device permissions assignments
	/// 
	/// Updates the device permissions assignments if the current user has ADMIN permission or CREATE permission and also has all device permissions.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_ADMIN *OR* ROLE_USER_MANAGEMENT_CREATE 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The device permissions were successfully updated.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - id:
	///     Unique identifier of the managed object.
	public func updateDevicePermissionAssignments(body: C8yUpdatedDevicePermissions, id: String) -> AnyPublisher<Data, Error> {
		let requestBody = body
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<Data, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/devicePermissions/\(id)")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "application/json")
			.add(header: "Accept", value: "application/json")
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
		}).eraseToAnyPublisher()
	}
}
