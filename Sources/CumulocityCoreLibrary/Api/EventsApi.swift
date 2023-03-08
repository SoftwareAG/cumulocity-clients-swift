//
// EventsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// Events are used to pass real-time information through Cumulocity IoT.
/// 
/// > **ⓘ Note** The Accept header should be provided in all POST/PUT requests, otherwise an empty response body will be returned.
public class EventsApi: AdaptableApi {

	/// Retrieve all events
	/// 
	/// Retrieve all events on your tenant.
	/// 
	/// In case of executing [range queries](https://en.wikipedia.org/wiki/Range_query_(database)) between an upper and lower boundary, for example, querying using `dateFrom`–`dateTo` or `createdFrom`–`createdTo`, the newest registered events are returned first. It is possible to change the order using the query parameter `revert=true`.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_EVENT_READ 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and all events are sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// 
	/// - Parameters:
	///   - createdFrom:
	///     Start date or date and time of the event's creation (set by the platform during creation).
	///   - createdTo:
	///     End date or date and time of the event's creation (set by the platform during creation).
	///   - currentPage:
	///     The current page of the paginated results.
	///   - dateFrom:
	///     Start date or date and time of the event occurrence (provided by the device).
	///   - dateTo:
	///     End date or date and time of the event occurrence (provided by the device).
	///   - fragmentType:
	///     A characteristic which identifies a managed object or event, for example, geolocation, electricity sensor, relay state.
	///   - fragmentValue:
	///     Allows filtering events by the fragment's value, but only when provided together with `fragmentType`.
	///     
	///     **⚠️ Important:** Only fragments with a string value are supported.
	///   - lastUpdatedFrom:
	///     Start date or date and time of the last update made.
	///   - lastUpdatedTo:
	///     End date or date and time of the last update made.
	///   - pageSize:
	///     Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	///   - revert:
	///     If you are using a range query (that is, at least one of the `dateFrom` or `dateTo` parameters is included in the request), then setting `revert=true` will sort the results by the oldest events first.By default, the results are sorted by the newest events first.
	///   - source:
	///     The managed object ID to which the event is associated.
	///   - type:
	///     The type of event to search for.
	///   - withSourceAssets:
	///     When set to `true` also events for related source assets will be included in the request. When this parameter is provided a `source` must be specified.
	///   - withSourceDevices:
	///     When set to `true` also events for related source devices will be included in the request. When this parameter is provided a `source` must be specified.
	///   - withTotalElements:
	///     When set to `true`, the returned result will contain in the statistics object the total number of elements. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	///   - withTotalPages:
	///     When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getEvents(createdFrom: String? = nil, createdTo: String? = nil, currentPage: Int? = nil, dateFrom: String? = nil, dateTo: String? = nil, fragmentType: String? = nil, fragmentValue: String? = nil, lastUpdatedFrom: String? = nil, lastUpdatedTo: String? = nil, pageSize: Int? = nil, revert: Bool? = nil, source: String? = nil, type: String? = nil, withSourceAssets: Bool? = nil, withSourceDevices: Bool? = nil, withTotalElements: Bool? = nil, withTotalPages: Bool? = nil) -> AnyPublisher<C8yEventCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/event/events")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.eventcollection+json")
			.add(queryItem: "createdFrom", value: createdFrom)
			.add(queryItem: "createdTo", value: createdTo)
			.add(queryItem: "currentPage", value: currentPage)
			.add(queryItem: "dateFrom", value: dateFrom)
			.add(queryItem: "dateTo", value: dateTo)
			.add(queryItem: "fragmentType", value: fragmentType)
			.add(queryItem: "fragmentValue", value: fragmentValue)
			.add(queryItem: "lastUpdatedFrom", value: lastUpdatedFrom)
			.add(queryItem: "lastUpdatedTo", value: lastUpdatedTo)
			.add(queryItem: "pageSize", value: pageSize)
			.add(queryItem: "revert", value: revert)
			.add(queryItem: "source", value: source)
			.add(queryItem: "type", value: type)
			.add(queryItem: "withSourceAssets", value: withSourceAssets)
			.add(queryItem: "withSourceDevices", value: withSourceDevices)
			.add(queryItem: "withTotalElements", value: withTotalElements)
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
		}).decode(type: C8yEventCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create an event
	/// 
	/// An event must be associated with a source (managed object) identified by an ID.
	/// In general, each event consists of:
	/// 
	/// * A type to identify the nature of the event.
	/// * A time stamp to indicate when the event was last updated.
	/// * A description of the event.
	/// * The managed object which originated the event.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_EVENT_ADMIN *OR* owner of the source *OR* EVENT_ADMIN permission on the source 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 An event was created.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// * HTTP 422 Unprocessable Entity – invalid payload.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func createEvent(body: C8yEvent, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<C8yEvent, Error> {
		var requestBody = body
		requestBody.lastUpdated = nil
		requestBody.creationTime = nil
		requestBody.`self` = nil
		requestBody.id = nil
		requestBody.source?.`self` = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yEvent, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/event/events")
			.set(httpMethod: "post")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.event+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.event+json")
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
		}).decode(type: C8yEvent.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove event collections
	/// 
	/// Remove event collections specified by query parameters.
	/// 
	/// DELETE requests are not synchronous. The response could be returned before the delete request has been completed. This may happen especially when the deleted event has a lot of associated data. After sending the request, the platform starts deleting the associated data in an asynchronous way. Finally, the requested event is deleted after all associated data has been deleted.
	/// 
	/// > **⚠️ Important:** Note that it is possible to call this endpoint without providing any parameter - it will result in deleting all events and it is not recommended.
	/// 
	/// > Tip: Required roles
	///  ROLE_EVENT_ADMIN 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 A collection of events was removed.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// 
	/// - Parameters:
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	///   - createdFrom:
	///     Start date or date and time of the event's creation (set by the platform during creation).
	///   - createdTo:
	///     End date or date and time of the event's creation (set by the platform during creation).
	///   - dateFrom:
	///     Start date or date and time of the event occurrence (provided by the device).
	///   - dateTo:
	///     End date or date and time of the event occurrence (provided by the device).
	///   - fragmentType:
	///     A characteristic which identifies a managed object or event, for example, geolocation, electricity sensor, relay state.
	///   - source:
	///     The managed object ID to which the event is associated.
	///   - type:
	///     The type of event to search for.
	public func deleteEvents(xCumulocityProcessingMode: String? = nil, createdFrom: String? = nil, createdTo: String? = nil, dateFrom: String? = nil, dateTo: String? = nil, fragmentType: String? = nil, source: String? = nil, type: String? = nil) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/event/events")
			.set(httpMethod: "delete")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Accept", value: "application/json")
			.add(queryItem: "createdFrom", value: createdFrom)
			.add(queryItem: "createdTo", value: createdTo)
			.add(queryItem: "dateFrom", value: dateFrom)
			.add(queryItem: "dateTo", value: dateTo)
			.add(queryItem: "fragmentType", value: fragmentType)
			.add(queryItem: "source", value: source)
			.add(queryItem: "type", value: type)
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
	
	/// Retrieve a specific event
	/// 
	/// Retrieve a specific event by a given ID.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_EVENT_READ *OR* owner of the source *OR* EVENT_READ permission on the source 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the event is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Event not found.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the event.
	public func getEvent(id: String) -> AnyPublisher<C8yEvent, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/event/events/\(id)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.event+json")
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
		}).decode(type: C8yEvent.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update a specific event
	/// 
	/// Update a specific event by a given ID. Only its text description and custom fragments can be updated.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_EVENT_ADMIN *OR* owner of the source *OR* EVENT_ADMIN permission on the source 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 An event was updated.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Event not found.
	/// * HTTP 422 Unprocessable Entity – invalid payload.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - id:
	///     Unique identifier of the event.
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func updateEvent(body: C8yEvent, id: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<C8yEvent, Error> {
		var requestBody = body
		requestBody.lastUpdated = nil
		requestBody.creationTime = nil
		requestBody.`self` = nil
		requestBody.id = nil
		requestBody.source = nil
		requestBody.time = nil
		requestBody.type = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yEvent, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/event/events/\(id)")
			.set(httpMethod: "put")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.event+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.event+json")
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
		}).decode(type: C8yEvent.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove a specific event
	/// 
	/// Remove a specific event by a given ID.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_EVENT_ADMIN *OR* owner of the source *OR* EVENT_ADMIN permission on the source 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 An event was removed.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// * HTTP 404 Event not found.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the event.
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func deleteEvent(id: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/event/events/\(id)")
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
