//
// CurrentUserApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// The current user is the user that is currently authenticated with Cumulocity IoT for the API calls.
/// 
/// > **&#9432; Info:** The Accept header should be provided in all PUT requests, otherwise an empty response body will be returned.
/// 
public class CurrentUserApi: AdaptableApi {

	/// Retrieve the current user
	/// Retrieve the user reference of the current user.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_USER_MANAGEMENT_OWN_READ <b>OR</b> ROLE_SYSTEM
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the current user is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	public func getCurrentUser() throws -> AnyPublisher<C8yCurrentUser, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/currentUser")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.currentuser+json")
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
		}).decode(type: C8yCurrentUser.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update the current user
	/// Update the current user.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_USER_MANAGEMENT_ADMIN
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The current user was updated.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 422
	///		  Unprocessable Entity – invalid payload.
	/// - Parameters:
	/// 	- body 
	public func updateCurrentUser(body: C8yCurrentUser) throws -> AnyPublisher<C8yCurrentUser, Swift.Error> {
		var requestBody = body
		requestBody.`self` = nil
		requestBody.effectiveRoles = nil
		requestBody.shouldResetPassword = nil
		requestBody.id = nil
		requestBody.lastPasswordChange = nil
		requestBody.devicePermissions = nil
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/currentUser")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.currentuser+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.currentuser+json")
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
			guard httpResponse.statusCode != 422 else {
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: "Unprocessable Entity – invalid payload.")
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yCurrentUser.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
