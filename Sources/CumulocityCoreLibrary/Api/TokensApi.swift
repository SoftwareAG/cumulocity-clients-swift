//
// TokensApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// In order to receive subscribed notifications, a consumer application or microservice must obtain an authorization token that provides proof that the holder is allowed to receive subscribed notifications.
public class TokensApi: AdaptableApi {

	public override init() {
		super.init()
	}

	public override init(requestBuilder: URLRequestBuilder) {
		super.init(requestBuilder: requestBuilder)
	}

	/// Create a notification token
	/// Create a new JWT (JSON web token) access token which can be used to establish a successful WebSocket connection to read a sequence of notifications.
	/// 
	/// In general, each request to obtain an access token consists of:
	/// 
	/// *  The subscriber name which the client wishes to be identified with.
	/// *  The subscription name. This value must be associated with a subscription that's already been created and in essence, the obtained token will give the ability to read notifications for the subscription that is specified here.
	/// *  The token expiration duration.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_NOTIFICATION_2_ADMIN
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  A notification token was created.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not enough permissions/roles to perform this operation.
	/// 	- 422
	///		  Unprocessable Entity – invalid payload.
	/// - Parameters:
	/// 	- body 
	public func postNotificationTokenResource(body: C8yNotificationTokenClaims) throws -> AnyPublisher<C8yNotificationToken, Swift.Error> {
		let requestBody = body
		let builder = URLRequestBuilder()
			.set(resourcePath: "/notification2/token")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/json")
			.set(httpBody: try JSONEncoder().encode(requestBody))
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yNotificationToken.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
