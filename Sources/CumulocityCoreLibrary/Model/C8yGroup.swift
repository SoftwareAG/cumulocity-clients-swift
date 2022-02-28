//
// C8yGroup.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yGroup: Codable {

	/// A URL linking to this resource.
	public var `self`: String?

	/// A unique identifier for this group.
	public var id: String?

	/// The name of the group.
	public var name: String?

	/// A list of applications.
	public var applications: [C8yApplication]?

	/// An object with a list of custom properties for this user.
	public var customProperties: C8yCustomProperties?

	/// An object with a list of the user's device permissions.
	@available(*, deprecated)
	public var devicePermissions: C8yDevicePermissions?

	/// An object containing user roles for this group.
	public var roles: C8yRoles?

	/// The list of users in this group.
	public var users: C8yUsers?

	enum CodingKeys: String, CodingKey {
		case `self` = "self"
		case id
		case name
		case applications
		case customProperties
		case devicePermissions
		case roles
		case users
	}

	public init() {
	}

	/// An object containing user roles for this group.
	public struct C8yRoles: Codable {
	
		/// A URL linking to this resource.
		public var `self`: String?
	
		/// A list of user roles.
		public var references: [C8yRole]?
	
		enum CodingKeys: String, CodingKey {
			case `self` = "self"
			case references
		}
	
		public init() {
		}
	}

	/// The list of users in this group.
	public struct C8yUsers: Codable {
	
		/// A URL linking to this resource.
		public var `self`: String?
	
		/// The list of users in this group.
		public var references: [C8yUser]?
	
		enum CodingKeys: String, CodingKey {
			case `self` = "self"
			case references
		}
	
		public init() {
		}
	}
}
