//
// C8yApplicationApiResource.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yApplicationApiResource: Codable {

	/// Collection of all applications..
	public var applications: String?

	/// A reference to a resource of type Application.
	public var applicationById: String?

	/// Read-only collection of all applications with a particular name.
	public var applicationsByName: String?

	/// Read-only collection of all applications subscribed by a particular tenant.
	public var applicationsByTenant: String?

	/// Read-only collection of all applications owned by a particular tenant.
	public var applicationsByOwner: String?

	/// Read-only collection of all applications owned by a particular user.
	public var applicationsByUser: String?

	/// A URL linking to this resource.
	public var `self`: String?

	enum CodingKeys: String, CodingKey {
		case applications
		case applicationById
		case applicationsByName
		case applicationsByTenant
		case applicationsByOwner
		case applicationsByUser
		case `self` = "self"
	}

	public init() {
	}
}
