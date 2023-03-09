//
// C8yUserApiResource.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yUserApiResource: Codable {

	/// A URL linking to this resource.
	public var `self`: String?

	/// Collection of all users belonging to a given tenant.
	public var users: String?

	/// Reference to a resource of type user.
	public var userByName: String?

	/// Reference to the resource of the logged in user.
	public var currentUser: String?

	/// Collection of all users belonging to a given tenant.
	public var groups: String?

	/// Reference to a resource of type group.
	public var groupByName: String?

	/// Collection of all roles.
	public var roles: String?

	enum CodingKeys: String, CodingKey {
		case `self` = "self"
		case users
		case userByName
		case currentUser
		case groups
		case groupByName
		case roles
	}

	public init() {
	}
}
