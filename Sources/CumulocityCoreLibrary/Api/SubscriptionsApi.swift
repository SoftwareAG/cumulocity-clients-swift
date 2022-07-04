//
// SubscriptionsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// Methods to create, retrieve and delete notification subscriptions.
public class SubscriptionsApi: AdaptableApi {

	/// Retrieve all subscriptions
	/// Retrieve all subscriptions on your tenant, or a specific subset based on queries.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_NOTIFICATION_2_ADMIN
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and all subscriptions are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not enough permissions/roles to perform this operation.
	/// - Parameters:
	/// 	- context 
	///		  The context to which the subscription is associated.
	/// 	- currentPage 
	///		  The current page of the paginated results.
	/// 	- pageSize 
	///		  Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	/// 	- source 
	///		  The managed object ID to which the subscription is associated.
	/// 	- withTotalPages 
	///		  When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getSubscriptions(context: String? = nil, currentPage: Int? = nil, pageSize: Int? = nil, source: String? = nil, withTotalPages: Bool? = nil) throws -> AnyPublisher<C8yNotificationSubscriptionCollection, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = context { queryItems.append(URLQueryItem(name: "context", value: String(parameter))) }
		if let parameter = currentPage { queryItems.append(URLQueryItem(name: "currentPage", value: String(parameter))) }
		if let parameter = pageSize { queryItems.append(URLQueryItem(name: "pageSize", value: String(parameter))) }
		if let parameter = source { queryItems.append(URLQueryItem(name: "source", value: String(parameter))) }
		if let parameter = withTotalPages { queryItems.append(URLQueryItem(name: "withTotalPages", value: String(parameter))) }
		let builder = URLRequestBuilder()
			.set(resourcePath: "/notification2/subscriptions")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.subscriptioncollection+json")
			.set(queryItems: queryItems)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error401)
			}
			guard httpResponse.statusCode != 403 else {
				let decoder = JSONDecoder()
				let error403 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error403)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yNotificationSubscriptionCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create a subscription
	/// Create a new subscription, for example, a subscription that forwards measurements and events of a specific type for a given device.
	/// 
	/// In general, each subscription may consist of:
	/// 
	/// *  The managed object to which the subscription is associated.
	/// *  The context under which the subscription is to be processed.
	/// *  The name of the subscription.
	/// *  The applicable filter criteria.
	/// *  The option to only include specific custom fragments in the forwarded data.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_NOTIFICATION_2_ADMIN
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  A notification subscription was created.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not enough permissions/roles to perform this operation.
	/// 	- 404
	///		  Managed object not found.
	/// 	- 409
	///		  Duplicated subscription.
	/// 	- 422
	///		  Unprocessable Entity – invalid payload.
	/// - Parameters:
	/// 	- body 
	public func createSubscription(body: C8yNotificationSubscription) throws -> AnyPublisher<C8yNotificationSubscription, Swift.Error> {
		var requestBody = body
		requestBody.`self` = nil
		requestBody.id = nil
		requestBody.source?.`self` = nil
		let builder = URLRequestBuilder()
			.set(resourcePath: "/notification2/subscriptions")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.subscription+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.subscription+json")
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
			guard httpResponse.statusCode != 403 else {
				let decoder = JSONDecoder()
				let error403 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error403)
			}
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error404)
			}
			guard httpResponse.statusCode != 409 else {
				let decoder = JSONDecoder()
				let error409 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error409)
			}
			guard httpResponse.statusCode != 422 else {
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: "Unprocessable Entity – invalid payload.")
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yNotificationSubscription.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove subscriptions by source
	/// Remove subscriptions by source and context.
	/// 
	/// >**&#9432; Info:** The request will result in an error if there are no query parameters. The `source` parameter is optional only if the `context` parameter equals `tenant`.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_NOTIFICATION_2_ADMIN
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  A collection of subscriptions was removed.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not enough permissions/roles to perform this operation.
	/// 	- 422
	///		  Unprocessable Entity – error in query parameters
	/// - Parameters:
	/// 	- context 
	///		  The context to which the subscription is associated. > **&#9432; Info:** If the value is `mo`, then `source` must also be provided in the query. 
	/// 	- source 
	///		  The managed object ID to which the subscription is associated.
	public func deleteSubscriptions(context: String? = nil, source: String? = nil) throws -> AnyPublisher<Data, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = context { queryItems.append(URLQueryItem(name: "context", value: String(parameter))) }
		if let parameter = source { queryItems.append(URLQueryItem(name: "source", value: String(parameter))) }
		let builder = URLRequestBuilder()
			.set(resourcePath: "/notification2/subscriptions")
			.set(httpMethod: "delete")
			.add(header: "Accept", value: "application/json")
			.set(queryItems: queryItems)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error401)
			}
			guard httpResponse.statusCode != 403 else {
				let decoder = JSONDecoder()
				let error403 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error403)
			}
			guard httpResponse.statusCode != 422 else {
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: "Unprocessable Entity – error in query parameters")
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific subscription
	/// Retrieve a specific subscription by a given ID.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_NOTIFICATION_2_ADMIN
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the subscription is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not enough permissions/roles to perform this operation.
	/// 	- 404
	///		  Subscription not found.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the notification subscription.
	public func getSubscription(id: String) throws -> AnyPublisher<C8yNotificationSubscription, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/notification2/subscriptions/\(id)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.subscription+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error401)
			}
			guard httpResponse.statusCode != 403 else {
				let decoder = JSONDecoder()
				let error403 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error403)
			}
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error404)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yNotificationSubscription.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove a specific subscription
	/// Remove a specific subscription by a given ID.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_NOTIFICATION_2_ADMIN
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  A subscription was removed.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not enough permissions/roles to perform this operation.
	/// 	- 404
	///		  Subscription not found.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the notification subscription.
	public func deleteSubscription(id: String) throws -> AnyPublisher<Data, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/notification2/subscriptions/\(id)")
			.set(httpMethod: "delete")
			.add(header: "Accept", value: "application/json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error401)
			}
			guard httpResponse.statusCode != 403 else {
				let decoder = JSONDecoder()
				let error403 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error403)
			}
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error404)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).eraseToAnyPublisher()
	}
}
