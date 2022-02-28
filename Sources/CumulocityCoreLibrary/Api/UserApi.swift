//
// UserApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// The user API resource returns URIs and URI templates to collections of users, groups, and roles, so that they can be queried.
public class UserApi: AdaptableApi {

	public override init() {
		super.init()
	}

	public override init(requestBuilder: URLRequestBuilder) {
		super.init(requestBuilder: requestBuilder)
	}

	/// Retrieve URIs to collections of users, groups and roles
	/// Retrieve URIs and URI templates to collections of users, groups, and roles, so that they can be queried.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_USER_MANAGEMENT_READ <b>OR</b> ROLE_USER_MANAGEMENT_CREATE
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the URIs are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	public func getUserApiResource() throws -> AnyPublisher<C8yUserApiResource, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.userapi+json, application/vnd.com.nsn.cumulocity.error+json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yUserApiResource.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
