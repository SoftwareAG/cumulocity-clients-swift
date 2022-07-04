//
// C8yDeviceStatistics.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// Statistics of a specific device (identified by an ID).
public struct C8yDeviceStatistics: Codable {

	/// Sum of measurements, events and alarms created and updated for the specified device.
	public var count: Int?

	/// Unique identifier of the device.
	public var deviceId: String?

	/// List of unique identifiers of parents for the corresponding device. Available only with monthly data.
	public var deviceParents: [String]?

	/// Value of the `type` field from the corresponding device. Available only with monthly data.
	public var deviceType: String?

	enum CodingKeys: String, CodingKey {
		case count
		case deviceId
		case deviceParents
		case deviceType
	}

	public init() {
	}
}
