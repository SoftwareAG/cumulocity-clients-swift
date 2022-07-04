//
// C8ySubscribedUser.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8ySubscribedUser: Codable {

	/// An object with a user reference URL.
	public var user: C8yUser?

	enum CodingKeys: String, CodingKey {
		case user
	}

	public init() {
	}

	/// An object with a user reference URL.
	public struct C8yUser: Codable {
	
		/// A URL linking to this resource.
		public var `self`: String?
	
		enum CodingKeys: String, CodingKey {
			case `self` = "self"
		}
	
		public init() {
		}
	}
}
