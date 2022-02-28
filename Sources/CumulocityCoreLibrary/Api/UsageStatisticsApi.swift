//
// UsageStatisticsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// Days are counted according to server timezone, so be aware that the tenant usage statistics displaying/filtering may not work correctly when the client is not in the same timezone as the server. However, it is possible to send a request with a time range (using the query parameters `dateFrom` and `dateTo`) in zoned format (e.g. `2020-10-26T03:00:00%2B01:00`).
/// 
/// ### Request counting in SmartREST and MQTT
/// 
/// * SmartREST: Each row in a SmartREST request is transformed into a separate HTTP request. For example, if one SmartREST request contains 10 rows, then 10 separate calls are executed, meaning that request count is increased by 10.
/// * MQTT: Each row/line counts as a separate request. Creating custom template counts as a single request.
/// 
/// ### REST specific counting details
/// 
/// * All counters increase also when the request is invalid, for example wrong payload or missing permissions.
/// * Bulk measurements creation and bulk alarm status update are counted as a single "requestCount"/"deviceRequestCount" and multiple inbound data transfer count.
/// 
/// ### SmartREST 1.0 specific counting details
/// 
/// * Invalid SmartREST requests are not counted, for example when the template doesn't exist.
/// * A new template registration is treated as two separate requests. Create a new inventory object which increases "requestCount", "deviceRequestCount" and "inventoriesCreatedCount". There is also a second request which binds the template with X-ID, this increases "requestCount" and "deviceRequestCount".
/// * Each row in a SmartREST request is transformed into a separate HTTP request. For example, if one SmartREST request contains 10 rows, then 10 separate calls are executed, meaning that both "requestCount" and "deviceRequestCount" are increased by 10.
/// 
/// ### MQTT specific counting details
/// 
/// * Invalid requests are counted, for example when sending a message with a wrong template ID.
/// * Device creation request and automatic device creation are counted.
/// * Each row/line counts as a separate request.
/// * Creating a custom template counts as a single request, no matter how many rows are sent in the request.
/// * There is one special SmartREST 2.0 template (402 Create location update event with device update) which is doing two things in one call, i.e. create a new location event and update the location of the device. It is counted as two separate requests.
/// 
/// ### JSON via MQTT specific counting details
/// 
/// * Invalid requests are counted, for example when the message payload is invalid.
/// * Bulk creation requests are counted as a single "requestCount"/"deviceRequestCount" and multiple inbound data transfer count.
/// * Bulk creation requests with a wrong payload are not counted for inbound data transfer count.
/// 
/// ### Total inbound data transfer
/// 
/// Inbound data transfer refers to the total number of inbound requests performed to transfer data into the Cumulocity IoT platform. This includes sensor readings, alarms, events, commands and alike that are transferred between devices and the Cumulocity IoT platform using the REST and/or MQTT interfaces. Such an inbound request could also originate from a custom microservice, website or any other client.
/// 
/// See the table below for more information on how the counters are increased. Additionally, it shows how inbound data transfers are handled for both MQTT and REST:
/// 
/// |Type of transfer|MQTT counter information|REST counter information|
/// |:---------------|:-----------------------|:-----------------------|
/// |Creation of an **alarm** in one request|One alarm creation is counted.|One alarm creation is counted via REST.|
/// |Update of an **alarm** (e.g. status change)|One alarm update is counted.|One alarm update is counted via REST.|
/// |Creation of **multiple alarms** in one request|Each alarm creation in a single MQTT request will be counted.|Not supported by C8Y (REST does not support creating multiple alarms in one call).|
/// |Update of **multiple alarms** (e.g. status change) in one request|Each alarm creation in a single MQTT request will be counted.|Not supported by C8Y (REST does not support updating multiple alarms in one call).|
/// |Creation of an **event** in one request|One event creation is counted.|One event creation is counted.|
/// |Update of an **event** (e.g. text change)|One event update is counted.|One event update is counted.|
/// |Creation of **multiple events** in one request|Each event creation in a single MQTT request will be counted.|Not supported by C8Y (REST does not support creating multiple events in one call).|
/// |Update of **multiple events** (e.g. text change) in one request|Each event update in a single MQTT request will be counted.|Not supported by C8Y (REST does not support updating multiple events in one call).|
/// |Creation of a **measurement** in one request|One measurement creation is counted. |One measurement creation is counted.|
/// |Creation of **multiple measurements** in one request|Each measurement creation in a single MQTT request will be counted. Example: If MQTT is used to report 5 measurements, the measurementCreated counter will be incremented by five.|REST allows multiple measurements to be created by sending multiple measurements in one call. In this case, each measurement sent via REST is counted individually. The call itself is not counted. For example, if somebody sends 5 measurements via REST in one call, the corresponding counter will be increased by 5. Measurements with multiple series are counted as a singular measurement.|
/// |Creation of a **managed object** in one request|One managed object creation is counted.|One managed object creation is counted.|
/// |Update of one **managed object** (e.g. status change)|One managed object update is counted.|One managed object update is counted.|
/// |Update of **multiple managed objects** in one request|Each managed object update in a single MQTT request will be counted.|Not supported by C8Y (REST does not support updating multiple managed objects in one call).|
/// |Creation/update of **multiple alarms/measurements/events/inventories** mixed in a single call.|Each MQTT line is processed separately. If it is a creation/update of an event/alarm/measurement/inventory, the corresponding counter is increased by one.|Not supported by the REST API.|
/// |Assign/unassign of **child devices and child assets** in one request|One managed object update is counted.|One managed object update is counted.|
/// 
/// ### Microservice usage statistics
/// 
/// The microservice usage statistics gathers information on the resource usage for tenants for each subscribed application which are collected on a daily base.
/// 
/// The microservice usage's information is stored in the `resources` object.
/// 
public class UsageStatisticsApi: AdaptableApi {

	public override init() {
		super.init()
	}

	public override init(requestBuilder: URLRequestBuilder) {
		super.init(requestBuilder: requestBuilder)
	}

	/// Retrieve statistics of the current tenant
	/// Retrieve usage statistics of the current tenant.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_TENANT_STATISTICS_READ
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the tenant statistics are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- currentPage 
	///		  The current page of the paginated results.
	/// 	- dateFrom 
	///		  Start date or date and time of the statistics.
	/// 	- dateTo 
	///		  End date or date and time of the statistics.
	/// 	- pageSize 
	///		  Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	/// 	- withTotalPages 
	///		  When set to true, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getTenantUsageStatisticsCollectionResource(currentPage: Int? = nil, dateFrom: String? = nil, dateTo: String? = nil, pageSize: Int? = nil, withTotalPages: Bool? = nil) throws -> AnyPublisher<C8yTenantUsageStatisticsCollection, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = currentPage { queryItems.append(URLQueryItem(name: "currentPage", value: String(parameter)))}
		if let parameter = dateFrom { queryItems.append(URLQueryItem(name: "dateFrom", value: String(parameter)))}
		if let parameter = dateTo { queryItems.append(URLQueryItem(name: "dateTo", value: String(parameter)))}
		if let parameter = pageSize { queryItems.append(URLQueryItem(name: "pageSize", value: String(parameter)))}
		if let parameter = withTotalPages { queryItems.append(URLQueryItem(name: "withTotalPages", value: String(parameter)))}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/statistics")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.tenantusagestatisticscollection+json")
			.set(queryItems: queryItems)
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yTenantUsageStatisticsCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a usage statistics summary
	/// Retrieve a usage statistics summary of a tenant.
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the usage statistics summary is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- dateFrom 
	///		  Start date or date and time of the statistics.
	/// 	- dateTo 
	///		  End date or date and time of the statistics.
	/// 	- tenant 
	///		  Unique identifier of a Cumulocity IoT tenant.
	public func getSummaryUsageStatistics(dateFrom: String? = nil, dateTo: String? = nil, tenant: String? = nil) throws -> AnyPublisher<C8ySummaryTenantUsageStatistics, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = dateFrom { queryItems.append(URLQueryItem(name: "dateFrom", value: String(parameter)))}
		if let parameter = dateTo { queryItems.append(URLQueryItem(name: "dateTo", value: String(parameter)))}
		if let parameter = tenant { queryItems.append(URLQueryItem(name: "tenant", value: String(parameter)))}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/statistics/summary")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.tenantusagestatisticssummary+json")
			.set(queryItems: queryItems)
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8ySummaryTenantUsageStatistics.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a summary of all usage statistics
	/// Retrieve a summary of all tenants usage statistics.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_TENANT_MANAGEMENT_READ
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the usage statistics summary is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- dateFrom 
	///		  Start date or date and time of the statistics.
	/// 	- dateTo 
	///		  End date or date and time of the statistics.
	public func getSummaryAllTenantsUsageStatistics(dateFrom: String? = nil, dateTo: String? = nil) throws -> AnyPublisher<[C8ySummaryAllTenantsUsageStatistics], Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = dateFrom { queryItems.append(URLQueryItem(name: "dateFrom", value: String(parameter)))}
		if let parameter = dateTo { queryItems.append(URLQueryItem(name: "dateTo", value: String(parameter)))}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/statistics/allTenantsSummary")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/json")
			.set(queryItems: queryItems)
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: [C8ySummaryAllTenantsUsageStatistics].self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
