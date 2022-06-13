//
// C8yAlarmsApiResource.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yAlarmsApiResource: Codable {

	/// Collection of all alarms
	public var alarms: C8yAlarms?

	/// Read-only collection of all alarms for a specific source object. The placeholder {source} must be a unique ID of an object in the inventory.
	public var alarmsForSource: String?

	/// Read-only collection of all alarms in a particular status. The placeholder {status} can be one of the following values: ACTIVE, ACKNOWLEDGED or CLEARED
	public var alarmsForStatus: String?

	/// Read-only collection of all alarms for a specific source, status and time range.
	public var alarmsForSourceAndStatusAndTime: String?

	/// Read-only collection of all alarms for a particular status and time range.
	public var alarmsForStatusAndTime: String?

	/// Read-only collection of all alarms for a specific source and time range.
	public var alarmsForSourceAndTime: String?

	/// Read-only collection of all alarms for a particular time range.
	public var alarmsForTime: String?

	/// Read-only collection of all alarms for a specific source object in a particular status.
	public var alarmsForSourceAndStatus: String?

	/// A URL linking to this resource.
	public var `self`: String?

	enum CodingKeys: String, CodingKey {
		case alarms
		case alarmsForSource
		case alarmsForStatus
		case alarmsForSourceAndStatusAndTime
		case alarmsForStatusAndTime
		case alarmsForSourceAndTime
		case alarmsForTime
		case alarmsForSourceAndStatus
		case `self` = "self"
	}

	public init() {
	}

	/// Collection of all alarms
	public struct C8yAlarms: Codable {
	
		/// A URL linking to this resource.
		public var `self`: String?
	
		public var alarms: [C8yAlarm]?
	
		enum CodingKeys: String, CodingKey {
			case `self` = "self"
			case alarms
		}
	
		public init() {
		}
	}
}
