//
// C8ySummaryAllTenantsUsageStatistics.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8ySummaryAllTenantsUsageStatistics: Codable {

	/// Number of created alarms.
	public var alarmsCreatedCount: Int?

	/// Number of updates made to the alarms.
	public var alarmsUpdatedCount: Int?

	/// Date and time of the tenant's creation.
	public var creationTime: String?

	/// Number of devices in the tenant identified by the fragment `c8y_IsDevice`. Updated only three times a day starting at 8:57, 16:57 and 23:57.
	public var deviceCount: Int?

	/// Number of devices which do not have child devices. Updated only three times a day starting at 8:57, 16:57 and 23:57.
	public var deviceEndpointCount: Int?

	/// Number of requests that were issued only by devices against the tenant. Updated every 5 minutes. The following requests are not included:
	/// 
	/// * Requests made to <kbd>/user</kbd>, <kbd>/tenant</kbd> and <kbd>/application</kbd> APIs
	/// * Application related requests (with `X-Cumulocity-Application-Key` header)
	public var deviceRequestCount: Int?

	/// Number of devices with children. Updated only three times a day starting at 8:57, 16:57 and 23:57.
	public var deviceWithChildrenCount: Int?

	/// Tenant external reference.
	public var externalReference: String?

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
	/// > **ⓘ Note** Bulk creation of measurements is handled in a way that each measurement is counted individually.
	public var measurementsCreatedCount: Int?

	/// ID of the parent tenant.
	public var parentTenantId: String?

	/// Peak value of `deviceCount` calculated for the requested time period of the summary.
	public var peakDeviceCount: Int?

	/// Peak value of `deviceWithChildrenCount` calculated for the requested time period of the summary.
	public var peakDeviceWithChildrenCount: Int?

	/// Peak value of used storage size in bytes, calculated for the requested time period of the summary.
	public var peakStorageSize: Int?

	/// Number of requests that were made against the tenant. Updated every 5 minutes. The following requests are not included:
	/// 
	/// * Internal SmartREST requests used to resolve templates
	/// * Internal SLA monitoring requests
	/// * Calls to any <kbd>/health</kbd> endpoint
	/// * Device bootstrap process requests related to configuring and retrieving device credentials
	/// * Microservice SDK internal calls for applications and subscriptions
	public var requestCount: Int?

	/// Resources usage for each subscribed microservice application.
	public var resources: C8yUsageStatisticsResources?

	/// Database storage in use, specified in bytes. It is affected by your retention rules and by the regularly running database optimization functions in Cumulocity IoT. If the size decreases, it does not necessarily mean that data was deleted. Updated only three times a day starting at 8:57, 16:57 and 23:57.
	public var storageSize: Int?

	/// Names of the tenant subscribed applications. Updated only three times a day starting at 8:57, 16:57 and 23:57.
	public var subscribedApplications: [String]?

	/// The tenant's company name.
	public var tenantCompany: String?

	/// An object with a list of custom properties.
	public var tenantCustomProperties: C8yCustomProperties?

	/// URL of the tenant's domain. The domain name permits only the use of alphanumeric characters separated by dots `.`, hyphens `-` and underscores `_`.
	public var tenantDomain: String?

	/// Unique identifier of a Cumulocity IoT tenant.
	public var tenantId: String?

	/// Sum of all inbound transfers.
	public var totalResourceCreateAndUpdateCount: Int?

	enum CodingKeys: String, CodingKey {
		case alarmsCreatedCount
		case alarmsUpdatedCount
		case creationTime
		case deviceCount
		case deviceEndpointCount
		case deviceRequestCount
		case deviceWithChildrenCount
		case externalReference
		case eventsCreatedCount
		case eventsUpdatedCount
		case inventoriesCreatedCount
		case inventoriesUpdatedCount
		case measurementsCreatedCount
		case parentTenantId
		case peakDeviceCount
		case peakDeviceWithChildrenCount
		case peakStorageSize
		case requestCount
		case resources
		case storageSize
		case subscribedApplications
		case tenantCompany
		case tenantCustomProperties
		case tenantDomain
		case tenantId
		case totalResourceCreateAndUpdateCount
	}

	public init() {
	}
}
