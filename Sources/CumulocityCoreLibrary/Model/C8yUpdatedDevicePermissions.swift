//
// C8yUpdatedDevicePermissions.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// A list of device permissions.
public struct C8yUpdatedDevicePermissions: Codable {

	public var users: [C8yUsers]?

	public var groups: [C8yGroups]?

	enum CodingKeys: String, CodingKey {
		case users
		case groups
	}

	public init() {
	}

	public struct C8yUsers: Codable {
	
		public var userName: String?
	
		/// An object with a list of the user's device permissions.
		@available(*, deprecated)
		public var devicePermissions: C8yDevicePermissions?
	
		enum CodingKeys: String, CodingKey {
			case userName
			case devicePermissions
		}
	
		public init() {
		}
	}

	public struct C8yGroups: Codable {
	
		public var id: String?
	
		/// An object with a list of the user's device permissions.
		@available(*, deprecated)
		public var devicePermissions: C8yDevicePermissions?
	
		enum CodingKeys: String, CodingKey {
			case id
			case devicePermissions
		}
	
		public init() {
		}
	}
}
