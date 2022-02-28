//
// C8yApplication.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yApplication: Codable {
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.`self` = try container.decodeIfPresent(String.self, forKey: .`self`)
		self.id = try container.decodeIfPresent(String.self, forKey: .id)
		self.activeVersionId = try container.decodeIfPresent(String.self, forKey: .activeVersionId)
		self.name = try container.decodeIfPresent(String.self, forKey: .name)
		self.key = try container.decodeIfPresent(String.self, forKey: .key)
		self.type = try container.decodeIfPresent(C8yApplicationType.self, forKey: .type)
		self.availability = try container.decodeIfPresent(C8yApplicationAvailability.self, forKey: .availability)
		self.contextPath = try container.decodeIfPresent(String.self, forKey: .contextPath)
		self.resourcesUrl = try container.decodeIfPresent(String.self, forKey: .resourcesUrl)
		self.globalTitle = try container.decodeIfPresent(String.self, forKey: .globalTitle)
		self.legacy = try container.decodeIfPresent(Bool.self, forKey: .legacy)
		self.dynamicOptionsUrl = try container.decodeIfPresent(String.self, forKey: .dynamicOptionsUrl)
		self.upgrade = try container.decodeIfPresent(Bool.self, forKey: .upgrade)
		self.rightDrawer = try container.decodeIfPresent(Bool.self, forKey: .rightDrawer)
		self.contentSecurityPolicy = try container.decodeIfPresent(String.self, forKey: .contentSecurityPolicy)
		self.breadcrumbs = try container.decodeIfPresent(Bool.self, forKey: .breadcrumbs)
		self.owner = try container.decodeIfPresent(C8yApplicationOwner.self, forKey: .owner)
		self.requiredRoles = try container.decodeIfPresent([String].self, forKey: .requiredRoles)
		self.roles = try container.decodeIfPresent([String].self, forKey: .roles)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(self.`self`, forKey: .`self`)
		try container.encodeIfPresent(self.id, forKey: .id)
		try container.encodeIfPresent(self.activeVersionId, forKey: .activeVersionId)
		try container.encodeIfPresent(self.name, forKey: .name)
		try container.encodeIfPresent(self.key, forKey: .key)
		try container.encodeIfPresent(self.type, forKey: .type)
		try container.encodeIfPresent(self.availability, forKey: .availability)
		try container.encodeIfPresent(self.contextPath, forKey: .contextPath)
		try container.encodeIfPresent(self.resourcesUrl, forKey: .resourcesUrl)
		try container.encodeIfPresent(self.globalTitle, forKey: .globalTitle)
		try container.encodeIfPresent(self.legacy, forKey: .legacy)
		try container.encodeIfPresent(self.dynamicOptionsUrl, forKey: .dynamicOptionsUrl)
		try container.encodeIfPresent(self.upgrade, forKey: .upgrade)
		try container.encodeIfPresent(self.rightDrawer, forKey: .rightDrawer)
		try container.encodeIfPresent(self.contentSecurityPolicy, forKey: .contentSecurityPolicy)
		try container.encodeIfPresent(self.breadcrumbs, forKey: .breadcrumbs)
		try container.encodeIfPresent(self.owner, forKey: .owner)
		try container.encodeIfPresent(self.requiredRoles, forKey: .requiredRoles)
		try container.encodeIfPresent(self.roles, forKey: .roles)
	}

	/// A URL linking to this resource.
	public var `self`: String?

	/// Unique identifier of the application.
	public var id: String?

	/// The active version ID of the application.
	/// For microservice applications the active version ID is the microservice manifest ID.
	/// 
	public var activeVersionId: String?

	/// Name of the application.
	public var name: String?

	/// Applications regardless of their form are identified by a so-called application key.
	/// The application key enables Cumulocity IoT to associate a REST request from an application with the particular application.
	/// 
	public var key: String?

	/// The type of the application.
	public var type: C8yApplicationType?

	/// Access level for other tenants.
	public var availability: C8yApplicationAvailability?

	/// The context path in the URL makes the application accessible.
	public var contextPath: String?

	/// URL to the application base directory hosted on an external server.
	/// 
	/// This is for legacy hosted applications.
	/// 
	@available(*, deprecated)
	public var resourcesUrl: String?

	/// The global title of the application.
	/// Only applicable for web applications.
	/// 
	public var globalTitle: String?

	/// A flag that shows if the application is a legacy application or not.
	/// Only applicable for web applications.
	/// 
	public var legacy: Bool?

	/// A URL to a JSON object with dynamic content options.
	/// Only applicable for web applications.
	/// 
	public var dynamicOptionsUrl: String?

	/// A flag that shows if the application is hybrid and using Angular and AngularJS simultaneously.
	/// Only applicable for web applications.
	/// 
	public var upgrade: Bool?

	/// A flag that decides if the application uses the context menu on the right in the UI or not.
	/// Only applicable for web applications.
	/// 
	public var rightDrawer: Bool?

	/// The content security policy of the application.
	/// Only applicable for web applications.
	/// 
	public var contentSecurityPolicy: String?

	/// A flag that shows if the application has a breadcrumbs navigation in the UI.
	/// Only applicable for web applications.
	/// 
	public var breadcrumbs: Bool?

	/// Reference to the tenant owning this application.
	public var owner: C8yApplicationOwner?

	/// List of permissions required by a microservice to work.
	public var requiredRoles: [String]?

	/// Roles provided by the microservice.
	public var roles: [String]?

	/// Note that the manifest is deprecated and will be empty for newer web applications.
	public var manifest: Any?

	enum CodingKeys: String, CodingKey {
		case `self` = "self"
		case id
		case activeVersionId
		case name
		case key
		case type
		case availability
		case contextPath
		case resourcesUrl
		case globalTitle
		case legacy
		case dynamicOptionsUrl
		case upgrade
		case rightDrawer
		case contentSecurityPolicy
		case breadcrumbs
		case owner
		case requiredRoles
		case roles
		case manifest
	}

	public init() {
	}
}
