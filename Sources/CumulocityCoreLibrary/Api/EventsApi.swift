//
// EventsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// Events are used to pass real-time information through Cumulocity IoT and they come in three types: base events  when something in the sensor network happens, alarms requiring manual actions, and audit logs to store events that are security-relevant.
/// 
/// > **&#9432; Info:** The Accept header should be provided in all POST/PUT requests, otherwise an empty response body will be returned.
/// 
public class EventsApi: AdaptableApi {

	/// Retrieve all events
	/// Retrieve all events on your tenant.
	/// 
	/// In case of executing [range queries](https://en.wikipedia.org/wiki/Range_query_(database)) between an upper and lower boundary, for example, querying using `dateFrom`–`dateTo` or `createdFrom`–`createdTo`, the newest registered events are returned first. It is possible to change the order using the query parameter `revert=true`.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_EVENT_READ
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and all events are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- createdFrom 
	///		  Start date or date and time of the event's creation (set by the platform during creation).
	/// 	- createdTo 
	///		  End date or date and time of the event's creation (set by the platform during creation).
	/// 	- currentPage 
	///		  The current page of the paginated results.
	/// 	- dateFrom 
	///		  Start date or date and time of the event occurrence (provided by the device).
	/// 	- dateTo 
	///		  End date or date and time of the event occurrence (provided by the device).
	/// 	- fragmentType 
	///		  A characteristic which identifies a managed object or event, for example, geolocation, electricity sensor, relay state.
	/// 	- fragmentValue 
	///		  Allows filtering events by the fragment's value, but only when provided together with `fragmentType`.  > **⚠️ Important:** Only fragments with a string value are supported. 
	/// 	- lastUpdatedFrom 
	///		  Start date or date and time of the last update made.
	/// 	- lastUpdatedTo 
	///		  End date or date and time of the last update made.
	/// 	- pageSize 
	///		  Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	/// 	- revert 
	///		  If you are using a range query (that is, at least one of the `dateFrom` or `dateTo` parameters is included in the request), then setting `revert=true` will sort the results by the oldest events first. By default, the results are sorted by the newest events first. 
	/// 	- source 
	///		  The managed object ID to which the event is associated.
	/// 	- type 
	///		  The type of event to search for.
	/// 	- withSourceAssets 
	///		  When set to `true` also events for related source assets will be included in the request. When this parameter is provided a `source` must be specified.
	/// 	- withSourceDevices 
	///		  When set to `true` also events for related source devices will be included in the request. When this parameter is provided a `source` must be specified.
	/// 	- withTotalElements 
	///		  When set to `true`, the returned result will contain in the statistics object the total number of elements. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	/// 	- withTotalPages 
	///		  When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getEvents(createdFrom: String? = nil, createdTo: String? = nil, currentPage: Int? = nil, dateFrom: String? = nil, dateTo: String? = nil, fragmentType: String? = nil, fragmentValue: String? = nil, lastUpdatedFrom: String? = nil, lastUpdatedTo: String? = nil, pageSize: Int? = nil, revert: Bool? = nil, source: String? = nil, type: String? = nil, withSourceAssets: Bool? = nil, withSourceDevices: Bool? = nil, withTotalElements: Bool? = nil, withTotalPages: Bool? = nil) throws -> AnyPublisher<C8yEventCollection, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = createdFrom { queryItems.append(URLQueryItem(name: "createdFrom", value: String(parameter))) }
		if let parameter = createdTo { queryItems.append(URLQueryItem(name: "createdTo", value: String(parameter))) }
		if let parameter = currentPage { queryItems.append(URLQueryItem(name: "currentPage", value: String(parameter))) }
		if let parameter = dateFrom { queryItems.append(URLQueryItem(name: "dateFrom", value: String(parameter))) }
		if let parameter = dateTo { queryItems.append(URLQueryItem(name: "dateTo", value: String(parameter))) }
		if let parameter = fragmentType { queryItems.append(URLQueryItem(name: "fragmentType", value: String(parameter))) }
		if let parameter = fragmentValue { queryItems.append(URLQueryItem(name: "fragmentValue", value: String(parameter))) }
		if let parameter = lastUpdatedFrom { queryItems.append(URLQueryItem(name: "lastUpdatedFrom", value: String(parameter))) }
		if let parameter = lastUpdatedTo { queryItems.append(URLQueryItem(name: "lastUpdatedTo", value: String(parameter))) }
		if let parameter = pageSize { queryItems.append(URLQueryItem(name: "pageSize", value: String(parameter))) }
		if let parameter = revert { queryItems.append(URLQueryItem(name: "revert", value: String(parameter))) }
		if let parameter = source { queryItems.append(URLQueryItem(name: "source", value: String(parameter))) }
		if let parameter = type { queryItems.append(URLQueryItem(name: "type", value: String(parameter))) }
		if let parameter = withSourceAssets { queryItems.append(URLQueryItem(name: "withSourceAssets", value: String(parameter))) }
		if let parameter = withSourceDevices { queryItems.append(URLQueryItem(name: "withSourceDevices", value: String(parameter))) }
		if let parameter = withTotalElements { queryItems.append(URLQueryItem(name: "withTotalElements", value: String(parameter))) }
		if let parameter = withTotalPages { queryItems.append(URLQueryItem(name: "withTotalPages", value: String(parameter))) }
		let builder = URLRequestBuilder()
			.set(resourcePath: "/event/events")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.eventcollection+json")
			.set(queryItems: queryItems)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error401)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yEventCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create an event
	/// An event must be associated with a source (managed object) identified by an ID.<br>
	/// In general, each event consists of:
	/// 
	/// *  A type to identify the nature of the event.
	/// *  A time stamp to indicate when the event was last updated.
	/// *  A description of the event.
	/// *  The managed object which originated the event.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_EVENT_ADMIN <b>OR</b> owner of the source <b>OR</b> EVENT_ADMIN permission on the source
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  An event was created.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not authorized to perform this operation.
	/// 	- 422
	///		  Unprocessable Entity – invalid payload.
	/// - Parameters:
	/// 	- body 
	public func createEvent(body: C8yEvent) throws -> AnyPublisher<C8yEvent, Swift.Error> {
		var requestBody = body
		requestBody.lastUpdated = nil
		requestBody.creationTime = nil
		requestBody.`self` = nil
		requestBody.id = nil
		requestBody.source?.`self` = nil
		let builder = URLRequestBuilder()
			.set(resourcePath: "/event/events")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.event+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.event+json")
			.set(httpBody: try JSONEncoder().encode(requestBody))
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error401)
			}
			guard httpResponse.statusCode != 403 else {
				throw Errors.badResponseError(response: httpResponse, reason: "Not authorized to perform this operation.")
			}
			guard httpResponse.statusCode != 422 else {
				throw Errors.badResponseError(response: httpResponse, reason: "Unprocessable Entity – invalid payload.")
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yEvent.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove event collections
	/// Remove event collections specified by query parameters.
	/// 
	/// DELETE requests are not synchronous. The response could be returned before the delete request has been completed. This may happen especially when the deleted event has a lot of associated data. After sending the request, the platform starts deleting the associated data in an asynchronous way. Finally, the requested event is deleted after all associated data has been deleted.
	/// 
	/// > **⚠️ Important:** Note that it is possible to call this endpoint without providing any parameter - it will result in deleting all events and it is not recommended.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_EVENT_ADMIN
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  A collection of events was removed.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not authorized to perform this operation.
	/// - Parameters:
	/// 	- createdFrom 
	///		  Start date or date and time of the event's creation (set by the platform during creation).
	/// 	- createdTo 
	///		  End date or date and time of the event's creation (set by the platform during creation).
	/// 	- dateFrom 
	///		  Start date or date and time of the event occurrence (provided by the device).
	/// 	- dateTo 
	///		  End date or date and time of the event occurrence (provided by the device).
	/// 	- fragmentType 
	///		  A characteristic which identifies a managed object or event, for example, geolocation, electricity sensor, relay state.
	/// 	- source 
	///		  The managed object ID to which the event is associated.
	/// 	- type 
	///		  The type of event to search for.
	public func deleteEvents(createdFrom: String? = nil, createdTo: String? = nil, dateFrom: String? = nil, dateTo: String? = nil, fragmentType: String? = nil, source: String? = nil, type: String? = nil) throws -> AnyPublisher<Data, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = createdFrom { queryItems.append(URLQueryItem(name: "createdFrom", value: String(parameter))) }
		if let parameter = createdTo { queryItems.append(URLQueryItem(name: "createdTo", value: String(parameter))) }
		if let parameter = dateFrom { queryItems.append(URLQueryItem(name: "dateFrom", value: String(parameter))) }
		if let parameter = dateTo { queryItems.append(URLQueryItem(name: "dateTo", value: String(parameter))) }
		if let parameter = fragmentType { queryItems.append(URLQueryItem(name: "fragmentType", value: String(parameter))) }
		if let parameter = source { queryItems.append(URLQueryItem(name: "source", value: String(parameter))) }
		if let parameter = type { queryItems.append(URLQueryItem(name: "type", value: String(parameter))) }
		let builder = URLRequestBuilder()
			.set(resourcePath: "/event/events")
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
				throw Errors.badResponseError(response: httpResponse, reason: error401)
			}
			guard httpResponse.statusCode != 403 else {
				throw Errors.badResponseError(response: httpResponse, reason: "Not authorized to perform this operation.")
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(response: httpResponse)
			}
			
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific event
	/// Retrieve a specific event by a given ID.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_EVENT_READ <b>OR</b> owner of the source <b>OR</b> EVENT_READ permission on the source
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the event is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Event not found.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the event.
	public func getEvent(id: String) throws -> AnyPublisher<C8yEvent, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/event/events/\(id)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.event+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error401)
			}
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error404)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yEvent.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update a specific event
	/// Update a specific event by a given ID. Only its text description and custom fragments can be updated.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_EVENT_ADMIN <b>OR</b> owner of the source <b>OR</b> EVENT_ADMIN permission on the source
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  An event was updated.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Event not found.
	/// 	- 422
	///		  Unprocessable Entity – invalid payload.
	/// - Parameters:
	/// 	- body 
	/// 	- id 
	///		  Unique identifier of the event.
	public func updateEvent(body: C8yEvent, id: String) throws -> AnyPublisher<C8yEvent, Swift.Error> {
		var requestBody = body
		requestBody.lastUpdated = nil
		requestBody.creationTime = nil
		requestBody.`self` = nil
		requestBody.id = nil
		requestBody.source = nil
		requestBody.time = nil
		requestBody.type = nil
		let builder = URLRequestBuilder()
			.set(resourcePath: "/event/events/\(id)")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.event+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.event+json")
			.set(httpBody: try JSONEncoder().encode(requestBody))
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error401)
			}
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error404)
			}
			guard httpResponse.statusCode != 422 else {
				throw Errors.badResponseError(response: httpResponse, reason: "Unprocessable Entity – invalid payload.")
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yEvent.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove a specific event
	/// Remove a specific event by a given ID.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_EVENT_ADMIN <b>OR</b> owner of the source <b>OR</b> EVENT_ADMIN permission on the source
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  An event was removed.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not authorized to perform this operation.
	/// 	- 404
	///		  Event not found.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the event.
	public func deleteEvent(id: String) throws -> AnyPublisher<Data, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/event/events/\(id)")
			.set(httpMethod: "delete")
			.add(header: "Accept", value: "application/json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error401)
			}
			guard httpResponse.statusCode != 403 else {
				throw Errors.badResponseError(response: httpResponse, reason: "Not authorized to perform this operation.")
			}
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error404)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(response: httpResponse)
			}
			
			return element.data
		}).eraseToAnyPublisher()
	}
}
