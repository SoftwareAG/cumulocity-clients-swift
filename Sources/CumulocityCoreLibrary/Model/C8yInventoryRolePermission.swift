//
// C8yInventoryRolePermission.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// A permission object of an inventory role.
public struct C8yInventoryRolePermission: Codable {

	/// The permission level.
	/// Allowed values are:
	/// 
	/// * `ADMIN`
	/// * `READ`
	/// * `*`
	/// 
	public var permission: String?

	/// A unique identifier for this permission.
	public var id: String?

	/// The type of this permission.
	public var type: String?

	/// The scope of this permission.
	public var scope: String?

	enum CodingKeys: String, CodingKey {
		case permission
		case id
		case type
		case scope
	}

	public init() {
	}
}
