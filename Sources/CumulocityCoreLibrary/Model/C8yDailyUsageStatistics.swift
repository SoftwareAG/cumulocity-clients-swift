//
// C8yDailyUsageStatistics.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// Daily usage statistics.
public struct C8yDailyUsageStatistics: Codable {

	/// Number of created alarms.
	public var alarmsCreatedCount: Int?

	/// Number of updates made to the alarms.
	public var alarmsUpdatedCount: Int?

	/// Date of this usage statistics object.
	public var day: String?

	/// Number of devices in the tenant identified by the fragment `c8y_IsDevice`. Updated only three times a day starting at 8:57, 16:57 and 23:57.
	public var deviceCount: Int?

	/// Number of devices which do not have child devices. Updated only three times a day starting at 8:57, 16:57 and 23:57.
	public var deviceEndpointCount: Int?

	/// Number of requests that were issued only by devices against the tenant. Updated every 5 minutes. The following requests are not included:
	/// 
	/// * Requests made to <kbd>/user</kbd>, <kbd>/tenant</kbd> and <kbd>/application</kbd> APIs
	/// * Application related requests (with `X-Cumulocity-Application-Key` header)
	/// 
	public var deviceRequestCount: Int?

	/// Number of devices with children. Updated only three times a day starting at 8:57, 16:57 and 23:57.
	public var deviceWithChildrenCount: Int?

	/// Number of created events.
	public var eventsCreatedCount: Int?

	/// Number of updates made to the events.
	public var eventsUpdatedCount: Int?

	/// Number of created managed objects.
	public var inventoriesCreatedCount: Int?

	/// Number of updates made to the managed objects.
	public var inventoriesUpdatedCount: Int?

	/// Number of created measurements.
	/// 
	/// > **&#9432; Info:** Bulk creation of measurements is handled in a way that each measurement is counted individually.
	/// 
	public var measurementsCreatedCount: Int?

	/// Number of requests that were made against the tenant. Updated every 5 minutes. The following requests are not included:
	/// 
	/// *  Internal SmartREST requests used to resolve templates
	/// *  Internal SLA monitoring requests
	/// *  Calls to any <kbd>/health</kbd> endpoint
	/// *  Device bootstrap process requests related to configuring and retrieving device credentials
	/// *  Microservice SDK internal calls for applications and subscriptions
	/// 
	public var requestCount: Int?

	/// Resources usage for each subscribed microservice application.
	public var resources: C8yUsageStatisticsResources?

	/// A URL linking to this resource.
	public var `self`: String?

	/// Database storage in use, specified in bytes. It is affected by your retention rules and by the regularly running database optimization functions in Cumulocity IoT. If the size decreases, it does not necessarily mean that data was deleted. Updated only three times a day starting at 8:57, 16:57 and 23:57.
	public var storageSize: Int?

	/// Names of the tenant subscribed applications. Updated only three times a day starting at 8:57, 16:57 and 23:57.
	public var subscribedApplications: [String]?

	/// Sum of all inbound transfers.
	public var totalResourceCreateAndUpdateCount: Int?

	enum CodingKeys: String, CodingKey {
		case alarmsCreatedCount
		case alarmsUpdatedCount
		case day
		case deviceCount
		case deviceEndpointCount
		case deviceRequestCount
		case deviceWithChildrenCount
		case eventsCreatedCount
		case eventsUpdatedCount
		case inventoriesCreatedCount
		case inventoriesUpdatedCount
		case measurementsCreatedCount
		case requestCount
		case resources
		case `self` = "self"
		case storageSize
		case subscribedApplications
		case totalResourceCreateAndUpdateCount
	}

	public init() {
	}
}
