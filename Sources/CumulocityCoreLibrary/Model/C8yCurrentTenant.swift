//
// C8yCurrentTenant.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yCurrentTenant: Codable {

	/// Indicates if this tenant can create subtenants.
	public var allowCreateTenants: Bool?

	/// A list of custom properties.
	public var customProperties: C8yCustomProperties?

	/// URL of the tenant's domain. The domain name permits only the use of alphanumeric characters separated by dots `.`, hyphens `-` and underscores `_`.
	public var domainName: String?

	/// Unique identifier of a Cumulocity IoT tenant.
	public var name: String?

	/// A URL linking to this resource.
	public var `self`: String?

	/// Collection of the subscribed applications.
	public var applications: C8yApplications?

	enum CodingKeys: String, CodingKey {
		case allowCreateTenants
		case customProperties
		case domainName
		case name
		case `self` = "self"
		case applications
	}

	public init() {
	}

	/// Collection of the subscribed applications.
	public struct C8yApplications: Codable {
	
		/// An array containing all subscribed applications.
		public var references: [C8yApplication]?
	
		enum CodingKeys: String, CodingKey {
			case references
		}
	
		public init() {
		}
	}
}
