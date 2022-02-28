//
// C8yBootstrapUser.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yBootstrapUser: Codable {

	/// The bootstrap user tenant password.
	public var password: String?

	/// The bootstrap user tenant username.
	public var name: String?

	/// The bootstrap user tenant ID.
	public var tenant: String?

	enum CodingKeys: String, CodingKey {
		case password
		case name
		case tenant
	}

	public init() {
	}
}
