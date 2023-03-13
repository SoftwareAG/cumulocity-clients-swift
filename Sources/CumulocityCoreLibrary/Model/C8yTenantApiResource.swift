//
// C8yTenantApiResource.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yTenantApiResource: Codable {

	/// Collection of tenant options
	public var options: C8yOptions?

	/// A URL linking to this resource.
	public var `self`: String?

	/// Collection of subtenants
	public var tenants: C8yTenants?

	/// Retrieves subscribed applications.
	public var tenantApplications: String?

	/// Represents an individual application reference that can be viewed.
	public var tenantApplicationForId: String?

	/// Represents an individual tenant that can be viewed.
	public var tenantForId: String?

	/// Represents a category of tenant options.
	public var tenantOptionsForCategory: String?

	/// Retrieves a key of the category of tenant options.
	public var tenantOptionForCategoryAndKey: String?

	/// Retrieves the tenant system options.
	public var tenantSystemOptions: String?

	/// Retrieves the tenant system options based on category and key.
	public var tenantSystemOptionsForCategoryAndKey: String?

	enum CodingKeys: String, CodingKey {
		case options
		case `self` = "self"
		case tenants
		case tenantApplications
		case tenantApplicationForId
		case tenantForId
		case tenantOptionsForCategory
		case tenantOptionForCategoryAndKey
		case tenantSystemOptions
		case tenantSystemOptionsForCategoryAndKey
	}

	public init() {
	}

	/// Collection of tenant options
	public struct C8yOptions: Codable {
	
		/// A URL linking to this resource.
		public var `self`: String?
	
		public var options: [C8yOption]?
	
		enum CodingKeys: String, CodingKey {
			case `self` = "self"
			case options
		}
	
		public init() {
		}
	}

	/// Collection of subtenants
	public struct C8yTenants: Codable {
	
		/// A URL linking to this resource.
		public var `self`: String?
	
		public var tenants: [C8yTenant]?
	
		enum CodingKeys: String, CodingKey {
			case `self` = "self"
			case tenants
		}
	
		public init() {
		}
	}
}
