//
// C8yGroup.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yGroup: Codable {

	/// A list of applications.
	public var applications: [C8yApplication]?

	/// An object with a list of custom properties.
	public var customProperties: C8yCustomProperties?

	/// A description of the group.
	public var description: String?

	/// An object with a list of the user's device permissions.
	@available(*, deprecated)
	public var devicePermissions: C8yDevicePermissions?

	/// A unique identifier for this group.
	public var id: Int?

	/// The name of the group.
	public var name: String?

	/// An object containing user roles for this group.
	public var roles: C8yRoles?

	/// A URL linking to this resource.
	public var `self`: String?

	/// The list of users in this group.
	public var users: C8yUsers?

	enum CodingKeys: String, CodingKey {
		case applications
		case customProperties
		case description
		case devicePermissions
		case id
		case name
		case roles
		case `self` = "self"
		case users
	}

	public init(name: String) {
		self.name = name
	}

	/// An object containing user roles for this group.
	public struct C8yRoles: Codable {
	
		/// A URL linking to this resource.
		public var `self`: String?
	
		/// A list of user role references.
		public var references: [C8yRoleReference]?
	
		/// Information about paging statistics.
		public var statistics: C8yPageStatistics?
	
		enum CodingKeys: String, CodingKey {
			case `self` = "self"
			case references
			case statistics
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
