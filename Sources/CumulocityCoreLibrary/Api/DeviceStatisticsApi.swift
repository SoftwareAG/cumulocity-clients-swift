//
// DeviceStatisticsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// Device statistics are collected for each inventory object with at least one measurement, event or alarm. There are no additional checks if the inventory object is marked as device using the `c8y_IsDevice` fragment. When the first measurement, event or alarm is created for a specific inventory object, Cumulocity IoT is always considering this as a device and starts counting.
/// 
/// Device statistics are counted with daily and monthy rate. All requests are considered when counting device statistics, no matter which processing mode is used.
/// 
/// The following requests are counted:
/// 
/// * Alarm creation and update
/// * Event creation and update
/// * Measurement creation
/// * Bulk measurement creation is counted as multiple requests
/// * Bulk alarm status update is counted as multiple requests
/// * MQTT and SmartREST requests with multiple rows are counted as multiple requests
/// 
/// ### Frequently asked questions
/// 
/// #### Are operations on device firmware counted?
/// 
/// **No**, device configuration and firmware update operate on inventory objects, hence they are not counted.
/// 
/// #### Are requests done by the UI applications, for example, when browsing device details, counted?
/// 
/// **No**, viewing device details performs only GET requests which are not counted.
/// 
/// #### Is the clear alarm operation done from the UI counted?
/// 
/// **Yes**, a clear alarm operation in fact performs an alarm update operation and it will be counted as device request.
/// 
/// #### Is there any operation performed on the device which is counted?
/// 
/// **Yes**, retrieving device logs requires from the device to create an event and attach a binary with logs to it. Those are two separate requests and both are counted.
/// 
/// #### When I have a device with children are the requests counted always to the root device or separately for each child?
/// 
/// Separately for each child.
/// 
public class DeviceStatisticsApi: AdaptableApi {

	/// Retrieve monthly device statistics
	/// Retrieve monthly device statistics from a specific tenant (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_TENANT_STATISTICS_READ
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the devices statistics are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not authorized to perform this operation.
	/// - Parameters:
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	/// 	- date 
	///		  Date (format YYYY-MM-dd) of the queried month (the day value is ignored).
	/// 	- currentPage 
	///		  The current page of the paginated results.
	/// 	- deviceId 
	///		  The ID of the device to search for.
	/// 	- pageSize 
	///		  Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	/// 	- withTotalPages 
	///		  When set to true, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getMonthlyDeviceStatistics(tenantId: String, date: Date, currentPage: Int? = nil, deviceId: String? = nil, pageSize: Int? = nil, withTotalPages: Bool? = nil) throws -> AnyPublisher<C8yDeviceStatisticsCollection, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = currentPage { queryItems.append(URLQueryItem(name: "currentPage", value: String(parameter)))}
		if let parameter = deviceId { queryItems.append(URLQueryItem(name: "deviceId", value: String(parameter)))}
		if let parameter = pageSize { queryItems.append(URLQueryItem(name: "pageSize", value: String(parameter)))}
		if let parameter = withTotalPages { queryItems.append(URLQueryItem(name: "withTotalPages", value: String(parameter)))}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/statistics/device/\(tenantId)/monthly/\(date)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/json")
			.set(queryItems: queryItems)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yDeviceStatisticsCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve daily device statistics
	/// Retrieve daily device statistics from a specific tenant (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_TENANT_STATISTICS_READ
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the devices statistics are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not authorized to perform this operation.
	/// - Parameters:
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	/// 	- date 
	///		  Date (format YYYY-MM-dd) of the queried day.
	/// 	- currentPage 
	///		  The current page of the paginated results.
	/// 	- deviceId 
	///		  The ID of the device to search for.
	/// 	- pageSize 
	///		  Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	/// 	- withTotalPages 
	///		  When set to true, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getDailyDeviceStatistics(tenantId: String, date: Date, currentPage: Int? = nil, deviceId: String? = nil, pageSize: Int? = nil, withTotalPages: Bool? = nil) throws -> AnyPublisher<C8yDeviceStatisticsCollection, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = currentPage { queryItems.append(URLQueryItem(name: "currentPage", value: String(parameter)))}
		if let parameter = deviceId { queryItems.append(URLQueryItem(name: "deviceId", value: String(parameter)))}
		if let parameter = pageSize { queryItems.append(URLQueryItem(name: "pageSize", value: String(parameter)))}
		if let parameter = withTotalPages { queryItems.append(URLQueryItem(name: "withTotalPages", value: String(parameter)))}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/statistics/device/\(tenantId)/daily/\(date)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/json")
			.set(queryItems: queryItems)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yDeviceStatisticsCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
