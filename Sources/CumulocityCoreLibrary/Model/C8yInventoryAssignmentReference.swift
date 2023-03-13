//
// C8yInventoryAssignmentReference.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// An inventory role reference.
public struct C8yInventoryAssignmentReference: Codable {

	/// An array of roles that are assigned to the managed object for the user.
	public var roles: [C8yRoles]?

	enum CodingKeys: String, CodingKey {
		case roles
	}

	public init() {
	}

	public struct C8yRoles: Codable {
	
		/// A unique identifier for this inventory role.
		public var id: Int?
	
		enum CodingKeys: String, CodingKey {
			case id
		}
	
		public init() {
		}
	}
}
