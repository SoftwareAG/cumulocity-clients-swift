//
// C8yRequiredAvailability.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// Devices can be monitored for availability by adding a `c8y_RequiredAvailability` fragment to the device.
/// 
/// Devices that have not sent any message in the response interval are considered disconnected. The response interval can have a value between `-32768` and `32767` and any values out of range will be shrunk to the range borders. Such devices are marked as unavailable and an unavailability alarm is raised.
public struct C8yRequiredAvailability: Codable {

	public var responseInterval: Int?

	enum CodingKeys: String, CodingKey {
		case responseInterval
	}

	public init() {
	}
}
