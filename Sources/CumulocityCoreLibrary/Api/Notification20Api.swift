//
// Notification20Api.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// The notification 2.0 API resource returns URIs and URI templates to collections of notifications, so that all notifications or notifications of a specified context and/or source device can be retrieved. See [Notifications 2.0](https://cumulocity.com/guides/reference/notifications) in the *Reference guide* for more details about the API and the consumer protocol.
public class Notification20Api: AdaptableApi {

	/// Retrieve URIs to collections of notification subscriptions
	/// Retrieve URIs and URI templates to collections of notification subscriptions.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_NOTIFICATION_2_ADMIN
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the URIs are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not enough permissions/roles to perform this operation.
	public func getNotificationApiResource() throws -> AnyPublisher<C8yNotificationApiResource, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/notification2")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.notificationapi+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yNotificationApiResource.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
