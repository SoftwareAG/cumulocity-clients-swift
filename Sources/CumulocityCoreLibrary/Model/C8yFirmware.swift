//
// C8yFirmware.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// Contains information on a device's firmware. In the inventory, `c8y_Firmware` represents the currently installed firmware on the device. As part of an operation, `c8y_Firmware` requests the device to install the indicated firmware. To enable firmware installation through the user interface, add `c8y_Firmware` to the list of supported operations.
public struct C8yFirmware: Codable {

	/// Name of the firmware.
	public var name: String?

	/// A version identifier of the firmware.
	public var version: String?

	/// A URI linking to the location to download the firmware from.
	public var url: String?

	enum CodingKeys: String, CodingKey {
		case name
		case version
		case url
	}

	public init() {
	}
}
