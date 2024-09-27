//
// C8yDevicePermissionOwners.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// A list of device permissions.
public struct C8yDevicePermissionOwners: Codable {

	public var users: [C8yUser]?

	public var groups: [C8yGroup]?

	enum CodingKeys: String, CodingKey {
		case users
		case groups
	}

	public init() {
	}
}
