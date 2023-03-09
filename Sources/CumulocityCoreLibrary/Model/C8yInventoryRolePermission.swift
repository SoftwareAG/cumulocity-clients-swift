//
// C8yInventoryRolePermission.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// A permission object of an inventory role.
public struct C8yInventoryRolePermission: Codable {

	/// A unique identifier for this permission.
	public var id: Int?

	/// The permission level.
	public var permission: C8yPermission?

	/// The scope of this permission.
	public var scope: C8yScope?

	/// The type of this permission. It can be the name of a fragment, for example, `c8y_Restart`.
	public var type: String?

	enum CodingKeys: String, CodingKey {
		case id
		case permission
		case scope
		case type
	}

	public init() {
	}

	/// The permission level.
	public enum C8yPermission: String, Codable {
		case admin = "ADMIN"
		case read = "READ"
		case all = "*"
	}

	/// The scope of this permission.
	public enum C8yScope: String, Codable {
		case alarm = "ALARM"
		case audit = "AUDIT"
		case event = "EVENT"
		case managedobject = "MANAGED_OBJECT"
		case measurement = "MEASUREMENT"
		case operation = "OPERATION"
		case all = "*"
	}


}
