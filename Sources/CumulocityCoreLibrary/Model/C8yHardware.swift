//
// C8yHardware.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// Contains basic hardware information for a device, such as make and serial number. Often, the hardware serial number is printed on the board of the device or on an asset tag on the device to uniquely identify the device within all devices of the same make.
public struct C8yHardware: Codable {

	/// A text identifier of the device's hardware model.
	public var model: String?

	/// A text identifier of the hardware revision.
	public var revision: String?

	/// The hardware serial number of the device.
	public var serialNumber: String?

	enum CodingKeys: String, CodingKey {
		case model
		case revision
		case serialNumber
	}

	public init() {
	}
}
