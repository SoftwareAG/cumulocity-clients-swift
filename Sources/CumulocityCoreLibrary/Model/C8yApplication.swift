//
// C8yApplication.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yApplication: Codable {
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.availability = try container.decodeIfPresent(C8yAvailability.self, forKey: .availability)
		self.contextPath = try container.decodeIfPresent(String.self, forKey: .contextPath)
		self.description = try container.decodeIfPresent(String.self, forKey: .description)
		self.id = try container.decodeIfPresent(String.self, forKey: .id)
		self.key = try container.decodeIfPresent(String.self, forKey: .key)
		self.name = try container.decodeIfPresent(String.self, forKey: .name)
		self.owner = try container.decodeIfPresent(C8yApplicationOwner.self, forKey: .owner)
		self.`self` = try container.decodeIfPresent(String.self, forKey: .`self`)
		self.type = try container.decodeIfPresent(C8yType.self, forKey: .type)
		self.manifest = try container.decodeAnyIfPresent(forKey: .manifest)
		self.roles = try container.decodeIfPresent([String].self, forKey: .roles)
		self.requiredRoles = try container.decodeIfPresent([String].self, forKey: .requiredRoles)
		self.breadcrumbs = try container.decodeIfPresent(Bool.self, forKey: .breadcrumbs)
		self.contentSecurityPolicy = try container.decodeIfPresent(String.self, forKey: .contentSecurityPolicy)
		self.dynamicOptionsUrl = try container.decodeIfPresent(String.self, forKey: .dynamicOptionsUrl)
		self.globalTitle = try container.decodeIfPresent(String.self, forKey: .globalTitle)
		self.legacy = try container.decodeIfPresent(Bool.self, forKey: .legacy)
		self.rightDrawer = try container.decodeIfPresent(Bool.self, forKey: .rightDrawer)
		self.upgrade = try container.decodeIfPresent(Bool.self, forKey: .upgrade)
		self.activeVersionId = try container.decodeIfPresent(String.self, forKey: .activeVersionId)
		self.resourcesUrl = try container.decodeIfPresent(String.self, forKey: .resourcesUrl)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(self.availability, forKey: .availability)
		try container.encodeIfPresent(self.contextPath, forKey: .contextPath)
		try container.encodeIfPresent(self.description, forKey: .description)
		try container.encodeIfPresent(self.id, forKey: .id)
		try container.encodeIfPresent(self.key, forKey: .key)
		try container.encodeIfPresent(self.name, forKey: .name)
		try container.encodeIfPresent(self.owner, forKey: .owner)
		try container.encodeIfPresent(self.`self`, forKey: .`self`)
		try container.encodeIfPresent(self.type, forKey: .type)
		try container.encodeAnyIfPresent(self.manifest, forKey: .manifest)
		try container.encodeIfPresent(self.roles, forKey: .roles)
		try container.encodeIfPresent(self.requiredRoles, forKey: .requiredRoles)
		try container.encodeIfPresent(self.breadcrumbs, forKey: .breadcrumbs)
		try container.encodeIfPresent(self.contentSecurityPolicy, forKey: .contentSecurityPolicy)
		try container.encodeIfPresent(self.dynamicOptionsUrl, forKey: .dynamicOptionsUrl)
		try container.encodeIfPresent(self.globalTitle, forKey: .globalTitle)
		try container.encodeIfPresent(self.legacy, forKey: .legacy)
		try container.encodeIfPresent(self.rightDrawer, forKey: .rightDrawer)
		try container.encodeIfPresent(self.upgrade, forKey: .upgrade)
		try container.encodeIfPresent(self.activeVersionId, forKey: .activeVersionId)
		try container.encodeIfPresent(self.resourcesUrl, forKey: .resourcesUrl)
	}

	/// Application access level for other tenants.
	public var availability: C8yAvailability?

	/// The context path in the URL makes the application accessible. Mandatory when the type of the application is `HOSTED`.
	public var contextPath: String?

	/// Description of the application.
	public var description: String?

	/// Unique identifier of the application.
	public var id: String?

	/// Applications, regardless of their form, are identified by an application key.
	public var key: String?

	/// Name of the application.
	public var name: String?

	/// Reference to the tenant owning this application. The default value is a reference to the current tenant.
	public var owner: C8yApplicationOwner?

	/// A URL linking to this resource.
	public var `self`: String?

	/// The type of the application.
	public var type: C8yType?

	public var manifest: Any?

	/// Roles provided by the microservice.
	public var roles: [String]?

	/// List of permissions required by a microservice to work.
	public var requiredRoles: [String]?

	/// A flag to indicate if the application has a breadcrumbs navigation on the UI.
	/// > **&#9432; Info:** This property is specific to the web application type.
	/// 
	public var breadcrumbs: Bool?

	/// The content security policy of the application.
	/// > **&#9432; Info:** This property is specific to the web application type.
	/// 
	public var contentSecurityPolicy: String?

	/// A URL to a JSON object with dynamic content options.
	/// > **&#9432; Info:** This property is specific to the web application type.
	/// 
	public var dynamicOptionsUrl: String?

	/// The global title of the application.
	/// > **&#9432; Info:** This property is specific to the web application type.
	/// 
	public var globalTitle: String?

	/// A flag that shows if the application is a legacy application or not.
	/// > **&#9432; Info:** This property is specific to the web application type.
	/// 
	public var legacy: Bool?

	/// A flag to indicate if the application uses the UI context menu on the right side.
	/// > **&#9432; Info:** This property is specific to the web application type.
	/// 
	public var rightDrawer: Bool?

	/// A flag that shows if the application is hybrid and using Angular and AngularJS simultaneously.
	/// > **&#9432; Info:** This property is specific to the web application type.
	/// 
	public var upgrade: Bool?

	/// The active version ID of the application. For microservice applications the active version ID is the microservice manifest version ID.
	public var activeVersionId: String?

	/// URL to the application base directory hosted on an external server. Only present in legacy hosted applications.
	@available(*, deprecated)
	public var resourcesUrl: String?

	enum CodingKeys: String, CodingKey {
		case availability
		case contextPath
		case description
		case id
		case key
		case name
		case owner
		case `self` = "self"
		case type
		case manifest
		case roles
		case requiredRoles
		case breadcrumbs
		case contentSecurityPolicy
		case dynamicOptionsUrl
		case globalTitle
		case legacy
		case rightDrawer
		case upgrade
		case activeVersionId
		case resourcesUrl
	}

	public init() {
	}

	/// Application access level for other tenants.
	public enum C8yAvailability: String, Codable {
		case market = "MARKET"
		case `private` = "PRIVATE"
	}

	/// The type of the application.
	public enum C8yType: String, Codable {
		case external = "EXTERNAL"
		case hosted = "HOSTED"
		case microservice = "MICROSERVICE"
	}


}
