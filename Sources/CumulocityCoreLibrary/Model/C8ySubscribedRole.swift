//
// C8ySubscribedRole.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8ySubscribedRole: Codable {

	/// An object with a role reference URL.
	public var role: C8yRole?

	enum CodingKeys: String, CodingKey {
		case role
	}

	public init() {
	}

	/// An object with a role reference URL.
	public struct C8yRole: Codable {
	
		/// A URL linking to this resource.
		public var `self`: String?
	
		enum CodingKeys: String, CodingKey {
			case `self` = "self"
		}
	
		public init() {
		}
	}
}
