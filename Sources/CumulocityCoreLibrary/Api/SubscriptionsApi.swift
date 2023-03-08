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
	/// 
	/// Retrieve all subscriptions on your tenant, or a specific subset based on queries.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_NOTIFICATION_2_ADMIN 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and all subscriptions are sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not enough permissions/roles to perform this operation.
	/// 
	/// - Parameters:
	///   - context:
	///     The context to which the subscription is associated.
	///   - currentPage:
	///     The current page of the paginated results.
	///   - pageSize:
	///     Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	///   - source:
	///     The managed object ID to which the subscription is associated.
	///   - withTotalPages:
	///     When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getSubscriptions(context: String? = nil, currentPage: Int? = nil, pageSize: Int? = nil, source: String? = nil, withTotalPages: Bool? = nil) -> AnyPublisher<C8yNotificationSubscriptionCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/notification2/subscriptions")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.subscriptioncollection+json")
			.add(queryItem: "context", value: context)
			.add(queryItem: "currentPage", value: currentPage)
			.add(queryItem: "pageSize", value: pageSize)
			.add(queryItem: "source", value: source)
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
		}).decode(type: C8yNotificationSubscriptionCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create a subscription
	/// 
	/// Create a new subscription, for example, a subscription that forwards measurements and events of a specific type for a given device.
	/// 
	/// In general, each subscription may consist of:
	/// 
	/// * The managed object to which the subscription is associated.
	/// * The context under which the subscription is to be processed.
	/// * The name of the subscription.
	/// * The applicable filter criteria.
	/// * The option to only include specific custom fragments in the forwarded data.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_NOTIFICATION_2_ADMIN 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 A notification subscription was created.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not enough permissions/roles to perform this operation.
	/// * HTTP 404 Managed object not found.
	/// * HTTP 409 Duplicated subscription.
	/// * HTTP 422 Unprocessable Entity – invalid payload.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func createSubscription(body: C8yNotificationSubscription, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<C8yNotificationSubscription, Error> {
		var requestBody = body
		requestBody.`self` = nil
		requestBody.id = nil
		requestBody.source?.`self` = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yNotificationSubscription, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/notification2/subscriptions")
			.set(httpMethod: "post")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.subscription+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.subscription+json")
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
		}).decode(type: C8yNotificationSubscription.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove subscriptions by source
	/// 
	/// Remove subscriptions by source and context.
	/// 
	/// > **ⓘ Note** The request will result in an error if there are no query parameters. The `source` parameter is optional only if the `context` parameter equals `tenant`.
	/// 
	/// > Tip: Required roles
	///  ROLE_NOTIFICATION_2_ADMIN 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 A collection of subscriptions was removed.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not enough permissions/roles to perform this operation.
	/// * HTTP 422 Unprocessable Entity – error in query parameters
	/// 
	/// - Parameters:
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	///   - context:
	///     The context to which the subscription is associated.
	///     
	///     **ⓘ Note** If the value is `mo`, then `source` must also be provided in the query.
	///   - source:
	///     The managed object ID to which the subscription is associated.
	public func deleteSubscriptions(xCumulocityProcessingMode: String? = nil, context: String? = nil, source: String? = nil) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/notification2/subscriptions")
			.set(httpMethod: "delete")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Accept", value: "application/json")
			.add(queryItem: "context", value: context)
			.add(queryItem: "source", value: source)
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
	
	/// Retrieve a specific subscription
	/// 
	/// Retrieve a specific subscription by a given ID.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_NOTIFICATION_2_ADMIN 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the subscription is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not enough permissions/roles to perform this operation.
	/// * HTTP 404 Subscription not found.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the notification subscription.
	public func getSubscription(id: String) -> AnyPublisher<C8yNotificationSubscription, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/notification2/subscriptions/\(id)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.subscription+json")
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
		}).decode(type: C8yNotificationSubscription.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove a specific subscription
	/// 
	/// Remove a specific subscription by a given ID.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_NOTIFICATION_2_ADMIN 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 A subscription was removed.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not enough permissions/roles to perform this operation.
	/// * HTTP 404 Subscription not found.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the notification subscription.
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func deleteSubscription(id: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/notification2/subscriptions/\(id)")
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
