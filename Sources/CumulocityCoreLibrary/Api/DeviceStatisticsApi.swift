//
// DeviceStatisticsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
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
/// > Tip: Frequently asked questions
/// > Tip: Are operations on device firmware counted?
/// **No**, device configuration and firmware update operate on inventory objects, hence they are not counted.
/// 
/// > Tip: Are requests done by the UI applications, for example, when browsing device details, counted?
/// **No**, viewing device details performs only GET requests which are not counted.
/// 
/// > Tip: Is the clear alarm operation done from the UI counted?
/// **Yes**, a clear alarm operation in fact performs an alarm update operation and it will be counted as device request.
/// 
/// > Tip: Is there any operation performed on the device which is counted?
/// **Yes**, retrieving device logs requires from the device to create an event and attach a binary with logs to it. Those are two separate requests and both are counted.
/// 
/// > Tip: When I have a device with children are the requests counted always to the root device or separately for each child?
/// Separately for each child.
/// 
/// > Tip: Why do device statistics show significantly smaller request numbers than the total number of created and updated request from usage statistics?
/// The important aspect here is the moment of recording values for the counters. For inbound data usage statistics we count every request that passed authorization, including invalid requests, as stated in usage statistics description.
/// 
/// For device statistics it is different. We count requests after data is successfully stored in the database (or transient), which means the request was valid and there was no problem with persistence.
/// 
/// In summary, if you observe that your usage statistics counters are significantly larger than your device statistics counters, there is a good chance that some devices or microservices in your tenant are constantly sending invalid requests. In such a situation, the client should check the state of theirs tenant.
public class DeviceStatisticsApi: AdaptableApi {

	/// Retrieve monthly device statistics
	/// 
	/// Retrieve monthly device statistics from a specific tenant (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_TENANT_STATISTICS_READ 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the devices statistics are sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// 
	/// - Parameters:
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	///   - date:
	///     Date (format YYYY-MM-dd) of the queried month (the day value is ignored).
	///   - currentPage:
	///     The current page of the paginated results.
	///   - deviceId:
	///     The ID of the device to search for.
	///   - pageSize:
	///     Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	///   - withTotalPages:
	///     When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getMonthlyDeviceStatistics(tenantId: String, date: Date, currentPage: Int? = nil, deviceId: String? = nil, pageSize: Int? = nil, withTotalPages: Bool? = nil) -> AnyPublisher<C8yDeviceStatisticsCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/statistics/device/\(tenantId)/monthly/\(date)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/json")
			.add(queryItem: "currentPage", value: currentPage)
			.add(queryItem: "deviceId", value: deviceId)
			.add(queryItem: "pageSize", value: pageSize)
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
		}).decode(type: C8yDeviceStatisticsCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve daily device statistics
	/// 
	/// Retrieve daily device statistics from a specific tenant (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_TENANT_STATISTICS_READ 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the devices statistics are sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// 
	/// - Parameters:
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	///   - date:
	///     Date (format YYYY-MM-dd) of the queried day.
	///   - currentPage:
	///     The current page of the paginated results.
	///   - deviceId:
	///     The ID of the device to search for.
	///   - pageSize:
	///     Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	///   - withTotalPages:
	///     When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getDailyDeviceStatistics(tenantId: String, date: Date, currentPage: Int? = nil, deviceId: String? = nil, pageSize: Int? = nil, withTotalPages: Bool? = nil) -> AnyPublisher<C8yDeviceStatisticsCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/statistics/device/\(tenantId)/daily/\(date)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/json")
			.add(queryItem: "currentPage", value: currentPage)
			.add(queryItem: "deviceId", value: deviceId)
			.add(queryItem: "pageSize", value: pageSize)
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
		}).decode(type: C8yDeviceStatisticsCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
