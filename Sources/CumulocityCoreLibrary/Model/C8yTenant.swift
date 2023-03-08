//
// C8yTenant.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yTenant: Codable {

	/// Email address of the tenant's administrator.
	public var adminEmail: String?

	/// Username of the tenant's administrator.
	/// 
	/// > **ⓘ Note** When it is provided in the request body, also `adminEmail` and `adminPass` must be provided.
	public var adminName: String?

	/// Password of the tenant's administrator.
	public var adminPass: String?

	/// Indicates if this tenant can create subtenants.
	public var allowCreateTenants: Bool?

	/// Collection of the subscribed applications.
	public var applications: C8yApplications?

	/// Tenant's company name.
	public var company: String?

	/// Name of the contact person.
	public var contactName: String?

	/// Phone number of the contact person, provided in the international format, for example, +48 123 456 7890.
	public var contactPhone: String?

	/// The date and time when the tenant was created.
	public var creationTime: String?

	/// An object with a list of custom properties.
	public var customProperties: C8yCustomProperties?

	/// URL of the tenant's domain. The domain name permits only the use of alphanumeric characters separated by dots `.` and hyphens `-`.
	public var domain: String?

	/// Unique identifier of a Cumulocity IoT tenant.
	public var id: String?

	/// Collection of the owned applications.
	public var ownedApplications: C8yOwnedApplications?

	/// ID of the parent tenant.
	public var parent: String?

	/// A URL linking to this resource.
	public var `self`: String?

	/// Current status of the tenant.
	public var status: C8yStatus?

	enum CodingKeys: String, CodingKey {
		case adminEmail
		case adminName
		case adminPass
		case allowCreateTenants
		case applications
		case company
		case contactName
		case contactPhone
		case creationTime
		case customProperties
		case domain
		case id
		case ownedApplications
		case parent
		case `self` = "self"
		case status
	}

	public init() {
	}

	/// Current status of the tenant.
	public enum C8yStatus: String, Codable {
		case active = "ACTIVE"
		case suspended = "SUSPENDED"
	}

	/// Collection of the subscribed applications.
	public struct C8yApplications: Codable {
	
		/// An array containing all subscribed applications.
		public var references: [C8yApplication]?
	
		/// A URL linking to this resource.
		public var `self`: String?
	
		enum CodingKeys: String, CodingKey {
			case references
			case `self` = "self"
		}
	
		public init() {
		}
	}

	/// Collection of the owned applications.
	public struct C8yOwnedApplications: Codable {
	
		/// An array containing all owned applications (only applications with availability MARKET).
		public var references: [C8yApplication]?
	
		/// A URL linking to this resource.
		public var `self`: String?
	
		enum CodingKeys: String, CodingKey {
			case references
			case `self` = "self"
		}
	
		public init() {
		}
	}

}
