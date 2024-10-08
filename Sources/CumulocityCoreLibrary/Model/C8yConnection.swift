//
// C8yConnection.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// The availability information computed by Cumulocity IoT is stored in fragments `c8y_Availability` and `c8y_Connection` of the device.
public struct C8yConnection: Codable {

	/// The current status, one of `AVAILABLE`, `CONNECTED`, `MAINTENANCE`, `DISCONNECTED`, `UNAVAILABLE`.
	public var status: C8yAvailabilityStatus?

	enum CodingKeys: String, CodingKey {
		case status
	}

	public init() {
	}
}
