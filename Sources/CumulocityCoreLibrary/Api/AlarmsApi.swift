//
// AlarmsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// An alarm represents an event that requires manual action, for example, when the temperature of a fridge increases above a particular threshold.
/// 
/// > **ⓘ Note** The Accept header should be provided in all POST/PUT requests, otherwise an empty response body will be returned.
public class AlarmsApi: AdaptableApi {

	/// Retrieve all alarms
	/// 
	/// Retrieve all alarms on your tenant, or a specific subset based on queries. The results are sorted by the newest alarms first.
	/// 
	/// > Tip: Query parameters
	/// The query parameter `withTotalPages` only works when the user has the ROLE_ALARM_READ role, otherwise it is ignored.
	/// 
	/// 
	/// > Tip: Required roles
	///  The role ROLE_ALARM_READ is not required, but if a user has this role, all the alarms on the tenant are returned. If a user has access to alarms through inventory roles, only those alarms are returned. 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and all alarms are sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// 
	/// - Parameters:
	///   - createdFrom:
	///     Start date or date and time of the alarm creation.
	///   - createdTo:
	///     End date or date and time of the alarm creation.
	///   - currentPage:
	///     The current page of the paginated results.
	///   - dateFrom:
	///     Start date or date and time of the alarm occurrence.
	///   - dateTo:
	///     End date or date and time of the alarm occurrence.
	///   - lastUpdatedFrom:
	///     Start date or date and time of the last update made.
	///   - lastUpdatedTo:
	///     End date or date and time of the last update made.
	///   - pageSize:
	///     Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	///   - resolved:
	///     When set to `true` only alarms with status CLEARED will be fetched, whereas `false` will fetch all alarms with status ACTIVE or ACKNOWLEDGED. Takes precedence over the `status` parameter.
	///   - severity:
	///     The severity of the alarm to search for.
	///     
	///     **ⓘ Note** If you query for multiple alarm severities at once, comma-separate the values.
	///   - source:
	///     The managed object ID to which the alarm is associated.
	///   - status:
	///     The status of the alarm to search for. Should not be used when `resolved` parameter is provided.
	///     
	///     **ⓘ Note** If you query for multiple alarm statuses at once, comma-separate the values.
	///   - type:
	///     The types of alarm to search for.
	///     
	///     **ⓘ Note** If you query for multiple alarm types at once, comma-separate the values. Space characters in alarm types must be escaped.
	///   - withSourceAssets:
	///     When set to `true` also alarms for related source assets will be included in the request. When this parameter is provided a `source` must be specified.
	///   - withSourceDevices:
	///     When set to `true` also alarms for related source devices will be included in the request. When this parameter is provided a `source` must be specified.
	///   - withTotalElements:
	///     When set to `true`, the returned result will contain in the statistics object the total number of elements. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	///   - withTotalPages:
	///     When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getAlarms(createdFrom: String? = nil, createdTo: String? = nil, currentPage: Int? = nil, dateFrom: String? = nil, dateTo: String? = nil, lastUpdatedFrom: String? = nil, lastUpdatedTo: String? = nil, pageSize: Int? = nil, resolved: Bool? = nil, severity: [String]? = nil, source: String? = nil, status: [String]? = nil, type: [String]? = nil, withSourceAssets: Bool? = nil, withSourceDevices: Bool? = nil, withTotalElements: Bool? = nil, withTotalPages: Bool? = nil) -> AnyPublisher<C8yAlarmCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/alarm/alarms")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.alarmcollection+json")
			.add(queryItem: "createdFrom", value: createdFrom)
			.add(queryItem: "createdTo", value: createdTo)
			.add(queryItem: "currentPage", value: currentPage)
			.add(queryItem: "dateFrom", value: dateFrom)
			.add(queryItem: "dateTo", value: dateTo)
			.add(queryItem: "lastUpdatedFrom", value: lastUpdatedFrom)
			.add(queryItem: "lastUpdatedTo", value: lastUpdatedTo)
			.add(queryItem: "pageSize", value: pageSize)
			.add(queryItem: "resolved", value: resolved)
			.add(queryItem: "severity", value: severity, explode: .comma_separated)
			.add(queryItem: "source", value: source)
			.add(queryItem: "status", value: status, explode: .comma_separated)
			.add(queryItem: "type", value: type, explode: .comma_separated)
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
		}).decode(type: C8yAlarmCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update alarm collections
	/// 
	/// Update alarm collections specified by query parameters. At least one query parameter is required to avoid accidentally updating all existing alarms.
	/// Currently, only the status of alarms can be modified.
	/// 
	/// > **ⓘ Note** Since this operation can take considerable time, the request returns after maximum 0.5 seconds of processing, and the update operation continues as a background process in the platform.
	/// 
	/// > Tip: Required roles
	///  ROLE_ALARM_ADMIN 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 An alarm collection was updated.
	/// * HTTP 202 An alarm collection is being updated in background.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// * HTTP 422 Unprocessable Entity – invalid payload.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	///   - createdFrom:
	///     Start date or date and time of the alarm creation.
	///   - createdTo:
	///     End date or date and time of the alarm creation.
	///   - dateFrom:
	///     Start date or date and time of the alarm occurrence.
	///   - dateTo:
	///     End date or date and time of the alarm occurrence.
	///   - resolved:
	///     When set to `true` only alarms with status CLEARED will be fetched, whereas `false` will fetch all alarms with status ACTIVE or ACKNOWLEDGED. Takes precedence over the `status` parameter.
	///   - severity:
	///     The severity of the alarm to search for.
	///     
	///     **ⓘ Note** If you query for multiple alarm severities at once, comma-separate the values.
	///   - source:
	///     The managed object ID to which the alarm is associated.
	///   - status:
	///     The status of the alarm to search for. Should not be used when `resolved` parameter is provided.
	///     
	///     **ⓘ Note** If you query for multiple alarm statuses at once, comma-separate the values.
	///   - withSourceAssets:
	///     When set to `true` also alarms for related source assets will be included in the request. When this parameter is provided a `source` must be specified.
	///   - withSourceDevices:
	///     When set to `true` also alarms for related source devices will be included in the request. When this parameter is provided a `source` must be specified.
	public func updateAlarms(body: C8yAlarm, xCumulocityProcessingMode: String? = nil, createdFrom: String? = nil, createdTo: String? = nil, dateFrom: String? = nil, dateTo: String? = nil, resolved: Bool? = nil, severity: [String]? = nil, source: String? = nil, status: [String]? = nil, withSourceAssets: Bool? = nil, withSourceDevices: Bool? = nil) -> AnyPublisher<Data, Error> {
		var requestBody = body
		requestBody.firstOccurrenceTime = nil
		requestBody.severity = nil
		requestBody.lastUpdated = nil
		requestBody.creationTime = nil
		requestBody.count = nil
		requestBody.`self` = nil
		requestBody.id = nil
		requestBody.source = nil
		requestBody.text = nil
		requestBody.time = nil
		requestBody.type = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<Data, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/alarm/alarms")
			.set(httpMethod: "put")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.alarm+json")
			.add(header: "Accept", value: "application/json")
			.add(queryItem: "createdFrom", value: createdFrom)
			.add(queryItem: "createdTo", value: createdTo)
			.add(queryItem: "dateFrom", value: dateFrom)
			.add(queryItem: "dateTo", value: dateTo)
			.add(queryItem: "resolved", value: resolved)
			.add(queryItem: "severity", value: severity, explode: .comma_separated)
			.add(queryItem: "source", value: source)
			.add(queryItem: "status", value: status, explode: .comma_separated)
			.add(queryItem: "withSourceAssets", value: withSourceAssets)
			.add(queryItem: "withSourceDevices", value: withSourceDevices)
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
		}).eraseToAnyPublisher()
	}
	
	/// Create an alarm
	/// 
	/// An alarm must be associated with a source (managed object) identified by ID.
	/// In general, each alarm may consist of:
	/// 
	/// * A status showing whether the alarm is ACTIVE, ACKNOWLEDGED or CLEARED.
	/// * A time stamp to indicate when the alarm was last updated.
	/// * The severity of the alarm: CRITICAL, MAJOR, MINOR or WARNING.
	/// * A history of changes to the event in form of audit logs.
	/// 
	/// > Tip: Alarm suppression
	/// If the source device is in maintenance mode, the alarm is not created and not reported to the Cumulocity IoT event processing engine. When sending a POST request to create a new alarm and if the source device is in maintenance mode, the self link of the alarm will be:
	/// 
	/// ```json
	/// "self": "https://<TENANT_DOMAIN>/alarm/alarms/null"
	/// ```
	/// > Tip: Alarm de-duplication
	/// If an ACTIVE or ACKNOWLEDGED alarm with the same source and type exists, no new alarm is created.Instead, the existing alarm is updated by incrementing the `count` property; the `time` property is also updated.Any other changes are ignored, and the alarm history is not updated. Alarms with status CLEARED are not de-duplicated.The first occurrence of the alarm is recorded in the `firstOccurrenceTime` property.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_ALARM_ADMIN *OR* owner of the source *OR* ALARM_ADMIN permission on the source 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 An alarm was created.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// * HTTP 422 Unprocessable Entity – invalid payload.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func createAlarm(body: C8yAlarm, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<C8yAlarm, Error> {
		var requestBody = body
		requestBody.firstOccurrenceTime = nil
		requestBody.lastUpdated = nil
		requestBody.creationTime = nil
		requestBody.count = nil
		requestBody.`self` = nil
		requestBody.id = nil
		requestBody.source?.`self` = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yAlarm, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/alarm/alarms")
			.set(httpMethod: "post")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.alarm+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.alarm+json")
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
		}).decode(type: C8yAlarm.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove alarm collections
	/// 
	/// Remove alarm collections specified by query parameters.
	/// 
	/// > **⚠️ Important:** DELETE requires at least one of the following parameters: `source`, `dateFrom`, `dateTo`, `createdFrom`, `createdTo`.Also note that DELETE requests are not synchronous. The response could be returned before the delete request has been completed.
	/// 
	/// > Tip: Required roles
	///  ROLE_ALARM_ADMIN 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 A collection of alarms was removed.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// 
	/// - Parameters:
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	///   - createdFrom:
	///     Start date or date and time of the alarm creation.
	///   - createdTo:
	///     End date or date and time of the alarm creation.
	///   - dateFrom:
	///     Start date or date and time of the alarm occurrence.
	///   - dateTo:
	///     End date or date and time of the alarm occurrence.
	///   - resolved:
	///     When set to `true` only alarms with status CLEARED will be fetched, whereas `false` will fetch all alarms with status ACTIVE or ACKNOWLEDGED. Takes precedence over the `status` parameter.
	///   - severity:
	///     The severity of the alarm to search for.
	///     
	///     **ⓘ Note** If you query for multiple alarm severities at once, comma-separate the values.
	///   - source:
	///     The managed object ID to which the alarm is associated.
	///   - status:
	///     The status of the alarm to search for. Should not be used when `resolved` parameter is provided.
	///     
	///     **ⓘ Note** If you query for multiple alarm statuses at once, comma-separate the values.
	///   - type:
	///     The types of alarm to search for.
	///     
	///     **ⓘ Note** If you query for multiple alarm types at once, comma-separate the values. Space characters in alarm types must be escaped.
	///   - withSourceAssets:
	///     When set to `true` also alarms for related source assets will be included in the request. When this parameter is provided a `source` must be specified.
	///   - withSourceDevices:
	///     When set to `true` also alarms for related source devices will be included in the request. When this parameter is provided a `source` must be specified.
	public func deleteAlarms(xCumulocityProcessingMode: String? = nil, createdFrom: String? = nil, createdTo: String? = nil, dateFrom: String? = nil, dateTo: String? = nil, resolved: Bool? = nil, severity: [String]? = nil, source: String? = nil, status: [String]? = nil, type: [String]? = nil, withSourceAssets: Bool? = nil, withSourceDevices: Bool? = nil) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/alarm/alarms")
			.set(httpMethod: "delete")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Accept", value: "application/json")
			.add(queryItem: "createdFrom", value: createdFrom)
			.add(queryItem: "createdTo", value: createdTo)
			.add(queryItem: "dateFrom", value: dateFrom)
			.add(queryItem: "dateTo", value: dateTo)
			.add(queryItem: "resolved", value: resolved)
			.add(queryItem: "severity", value: severity, explode: .comma_separated)
			.add(queryItem: "source", value: source)
			.add(queryItem: "status", value: status, explode: .comma_separated)
			.add(queryItem: "type", value: type, explode: .comma_separated)
			.add(queryItem: "withSourceAssets", value: withSourceAssets)
			.add(queryItem: "withSourceDevices", value: withSourceDevices)
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
	
	/// Retrieve a specific alarm
	/// 
	/// Retrieve a specific alarm by a given ID.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_ALARM_READ *OR* owner of the source *OR* ALARM_READ permission on the source 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the alarm is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// * HTTP 404 Alarm not found.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the alarm.
	public func getAlarm(id: String) -> AnyPublisher<C8yAlarm, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/alarm/alarms/\(id)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.alarm+json")
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
		}).decode(type: C8yAlarm.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update a specific alarm
	/// 
	/// Update a specific alarm by a given ID.Only text, status, severity and custom properties can be modified. A request will be rejected when non-modifiable properties are provided in the request body.
	/// 
	/// > **ⓘ Note** Changes to alarms will generate a new audit record. The audit record will include the username and application that triggered the update, if applicable. If the update operation doesn’t change anything (that is, the request body contains data that is identical to the already present in the database), there will be no audit record added and no notifications will be sent.
	/// 
	/// > Tip: Required roles
	///  ROLE_ALARM_ADMIN *OR* owner of the source *OR* ALARM_ADMIN permission on the source 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 An alarm was updated.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// * HTTP 404 Alarm not found.
	/// * HTTP 422 Unprocessable Entity – invalid payload.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - id:
	///     Unique identifier of the alarm.
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func updateAlarm(body: C8yAlarm, id: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<C8yAlarm, Error> {
		var requestBody = body
		requestBody.firstOccurrenceTime = nil
		requestBody.lastUpdated = nil
		requestBody.creationTime = nil
		requestBody.count = nil
		requestBody.`self` = nil
		requestBody.id = nil
		requestBody.source = nil
		requestBody.time = nil
		requestBody.type = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yAlarm, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/alarm/alarms/\(id)")
			.set(httpMethod: "put")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.alarm+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.alarm+json")
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
		}).decode(type: C8yAlarm.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve the total number of alarms
	/// 
	/// Count the total number of active alarms on your tenant.
	/// 
	/// 
	/// > Tip: Required roles
	///  The role ROLE_ALARM_READ is not required, but if a user has this role, all the alarms on the tenant are counted. Otherwise, inventory role permissions are used to count the alarms and the limit is 100. 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the number of active alarms is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// 
	/// - Parameters:
	///   - dateFrom:
	///     Start date or date and time of the alarm occurrence.
	///   - dateTo:
	///     End date or date and time of the alarm occurrence.
	///   - resolved:
	///     When set to `true` only alarms with status CLEARED will be fetched, whereas `false` will fetch all alarms with status ACTIVE or ACKNOWLEDGED. Takes precedence over the `status` parameter.
	///   - severity:
	///     The severity of the alarm to search for.
	///     
	///     **ⓘ Note** If you query for multiple alarm severities at once, comma-separate the values.
	///   - source:
	///     The managed object ID to which the alarm is associated.
	///   - status:
	///     The status of the alarm to search for. Should not be used when `resolved` parameter is provided.
	///     
	///     **ⓘ Note** If you query for multiple alarm statuses at once, comma-separate the values.
	///   - type:
	///     The types of alarm to search for.
	///     
	///     **ⓘ Note** If you query for multiple alarm types at once, comma-separate the values. Space characters in alarm types must be escaped.
	///   - withSourceAssets:
	///     When set to `true` also alarms for related source assets will be included in the request. When this parameter is provided a `source` must be specified.
	///   - withSourceDevices:
	///     When set to `true` also alarms for related source devices will be included in the request. When this parameter is provided a `source` must be specified.
	public func getNumberOfAlarms(dateFrom: String? = nil, dateTo: String? = nil, resolved: Bool? = nil, severity: [String]? = nil, source: String? = nil, status: [String]? = nil, type: [String]? = nil, withSourceAssets: Bool? = nil, withSourceDevices: Bool? = nil) -> AnyPublisher<Int, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/alarm/alarms/count")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, text/plain, application/json")
			.add(queryItem: "dateFrom", value: dateFrom)
			.add(queryItem: "dateTo", value: dateTo)
			.add(queryItem: "resolved", value: resolved)
			.add(queryItem: "severity", value: severity, explode: .comma_separated)
			.add(queryItem: "source", value: source)
			.add(queryItem: "status", value: status, explode: .comma_separated)
			.add(queryItem: "type", value: type, explode: .comma_separated)
			.add(queryItem: "withSourceAssets", value: withSourceAssets)
			.add(queryItem: "withSourceDevices", value: withSourceDevices)
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
		}).decode(type: Int.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
