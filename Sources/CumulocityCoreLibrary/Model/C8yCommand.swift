//
// C8yCommand.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// To carry out interactive sessions with a device, use the `c8y_Command` fragment. If this fragment is in the list of supported operations for a device, a tab `Shell` will be shown. Using the `Shell` tab, the user can send commands in an arbitrary, device-specific syntax to the device. The command is sent to the device in a property `text`.
public struct C8yCommand: Codable {

	/// The command sent to the device.
	public var type: String?

	/// To communicate the results of a particular command, the device adds a property `result`.
	public var result: String?

	enum CodingKeys: String, CodingKey {
		case type
		case result
	}

	public init() {
	}
}
