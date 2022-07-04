//
// C8yRole.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// A user role.
public struct C8yRole: Codable {

	/// A unique identifier for this user role.
	public var id: String?

	/// The name of this user role.
	public var name: String?

	/// A URL linking to this resource.
	public var `self`: String?

	enum CodingKeys: String, CodingKey {
		case id
		case name
		case `self` = "self"
	}

	public init() {
	}
}
