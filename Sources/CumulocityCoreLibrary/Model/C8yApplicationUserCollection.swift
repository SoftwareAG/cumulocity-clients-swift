//
// C8yApplicationUserCollection.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yApplicationUserCollection: Codable {

	/// A list of users who are subscribed to the current application.
	public var users: [C8yUsers]?

	enum CodingKeys: String, CodingKey {
		case users
	}

	public init() {
	}

	/// A user who is subscribed to the current application.
	public struct C8yUsers: Codable {
	
		/// The username.
		public var name: String?
	
		/// The user password.
		public var password: String?
	
		/// The user tenant.
		public var tenant: String?
	
		enum CodingKeys: String, CodingKey {
			case name
			case password
			case tenant
		}
	
		public init() {
		}
	}
}
