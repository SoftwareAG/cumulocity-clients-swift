//
// C8yManagedObjectUser.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yManagedObjectUser: Codable {

	/// Specifies if the device's owner is enabled or not.
	public var enabled: Bool?

	/// A URL linking to this resource.
	public var `self`: String?

	/// The username of the device's owner.
	public var userName: String?

	enum CodingKeys: String, CodingKey {
		case enabled
		case `self` = "self"
		case userName
	}

	public init() {
	}
}
