//
// EventApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// The event API resource returns URIs and URI templates to collections of events, so that all events or events of a specified type and/or source device can be retrieved.
public class EventApi: AdaptableApi {

	/// Retrieve URIs to collections of events
	/// Retrieve URIs and URI templates to collections of events.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_EVENT_READ
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the URIs are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	public func getEventsApiResource() throws -> AnyPublisher<C8yEventsApiResource, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/event")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.eventapi+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yEventsApiResource.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
