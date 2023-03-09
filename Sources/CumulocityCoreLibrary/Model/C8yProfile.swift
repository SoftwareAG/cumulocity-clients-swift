//
// C8yProfile.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// Device capability to manage device profiles. Device profiles represent a combination of a firmware version, one or multiple software packages and one or multiple configuration files which can be deployed on a device.
public struct C8yProfile: Codable {

	/// The name of the profile.
	public var profileName: String?

	/// The ID of the profile.
	public var profileId: String?

	/// Indicates whether the profile has been executed.
	public var profileExecuted: Bool?

	enum CodingKeys: String, CodingKey {
		case profileName
		case profileId
		case profileExecuted
	}

	public init() {
	}
}
