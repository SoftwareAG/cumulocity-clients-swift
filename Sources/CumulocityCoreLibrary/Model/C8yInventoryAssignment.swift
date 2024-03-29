//
// C8yInventoryAssignment.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// An inventory assignment.
public struct C8yInventoryAssignment: Codable {

	/// A unique identifier for this inventory assignment.
	public var id: Int?

	/// A unique identifier for the managed object for which the roles are assigned.
	public var managedObject: String?

	/// An array of roles that are assigned to the managed object for the user.
	public var roles: [C8yInventoryRole]?

	/// A URL linking to this resource.
	public var `self`: String?

	enum CodingKeys: String, CodingKey {
		case id
		case managedObject
		case roles
		case `self` = "self"
	}

	public init() {
	}
}
