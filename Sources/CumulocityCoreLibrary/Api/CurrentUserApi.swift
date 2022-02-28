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
/// > **&#9432; Info:** The Accept header should be provided in all PUT/POST requests, otherwise an empty response body will be returned.
/// 
public class CurrentUserApi: AdaptableApi {

	public override init() {
		super.init()
	}

	public override init(requestBuilder: URLRequestBuilder) {
		super.init(requestBuilder: requestBuilder)
	}

	/// Retrieve the current user
	/// 
	/// Retrieve the user reference of the current user.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_USER_MANAGEMENT_OWN_READ <b>OR</b> ROLE_SYSTEM
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the current user is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	public func getCurrentUserResource() throws -> AnyPublisher<C8yCurrentUser, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/currentUser")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.currentuser+json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yCurrentUser.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update the current user
	/// 
	/// Update the current user.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_USER_MANAGEMENT_ADMIN
	/// </div></div>
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
	public func putCurrentUserResource(body: C8yCurrentUser) throws -> AnyPublisher<C8yCurrentUser, Swift.Error> {
		var requestBody = body
		requestBody.`self` = nil
		requestBody.effectiveRoles = nil
		requestBody.id = nil
		requestBody.lastPasswordChange = nil
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/currentUser")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.currentuser+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.currentuser+json")
			.set(httpBody: try JSONEncoder().encode(requestBody))
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yCurrentUser.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
