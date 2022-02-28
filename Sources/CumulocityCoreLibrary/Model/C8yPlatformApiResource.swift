//
// C8yPlatformApiResource.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yPlatformApiResource: Codable {

	/// A URL linking to this resource.
	public var `self`: String?

	public var alarm: C8yAlarmsApiResource?

	public var audit: C8yAuditApiResource?

	public var deviceControl: C8yDeviceControlApiResource?

	public var event: C8yEventsApiResource?

	public var identity: C8yIdentityApiResource?

	public var inventory: C8yInventoryApiResource?

	public var measurement: C8yMeasurementApiResource?

	public var tenant: C8yTenantApiResource?

	public var user: C8yUserApiResource?

	enum CodingKeys: String, CodingKey {
		case `self` = "self"
		case alarm
		case audit
		case deviceControl
		case event
		case identity
		case inventory
		case measurement
		case tenant
		case user
	}

	public init() {
	}
}
