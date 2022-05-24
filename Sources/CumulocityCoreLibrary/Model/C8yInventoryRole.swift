//
// C8yInventoryRole.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// An inventory role.
public struct C8yInventoryRole: Codable {

	/// A description for this inventory role.
	public var description: String?

	/// A unique identifier for this inventory role.
	public var id: Int?

	/// The name of this inventory role.
	public var name: String?

	/// A set of permissions for this inventory role.
	public var permissions: [C8yInventoryRolePermission]?

	/// A URL linking to this resource.
	public var `self`: String?

	enum CodingKeys: String, CodingKey {
		case description
		case id
		case name
		case permissions
		case `self` = "self"
	}

	public init() {
	}
}
