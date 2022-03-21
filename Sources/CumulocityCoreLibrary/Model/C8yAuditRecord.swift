//
// C8yAuditRecord.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yAuditRecord: Codable {
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.activity = try container.decodeIfPresent(String.self, forKey: .activity)
		self.application = try container.decodeIfPresent(String.self, forKey: .application)
		self.c8yMetadata = try container.decodeIfPresent(C8yMetadata.self, forKey: .c8yMetadata)
		self.changes = try container.decodeIfPresent([C8yChanges].self, forKey: .changes)
		self.creationTime = try container.decodeIfPresent(String.self, forKey: .creationTime)
		self.id = try container.decodeIfPresent(String.self, forKey: .id)
		self.`self` = try container.decodeIfPresent(String.self, forKey: .`self`)
		self.severity = try container.decodeIfPresent(C8yAuditSeverity.self, forKey: .severity)
		self.source = try container.decodeIfPresent(C8yAuditSource.self, forKey: .source)
		self.text = try container.decodeIfPresent(String.self, forKey: .text)
		self.time = try container.decodeIfPresent(String.self, forKey: .time)
		self.type = try container.decodeIfPresent(C8yAuditType.self, forKey: .type)
		self.user = try container.decodeIfPresent(String.self, forKey: .user)
		if let additionalContainer = try? decoder.container(keyedBy: JSONCodingKeys.self) {
			for (typeName, decoder) in C8yAuditRecord.decoders {
				self.customProperties?[typeName] = try? decoder(additionalContainer)
			}
		}
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(self.activity, forKey: .activity)
		try container.encodeIfPresent(self.application, forKey: .application)
		try container.encodeIfPresent(self.c8yMetadata, forKey: .c8yMetadata)
		try container.encodeIfPresent(self.changes, forKey: .changes)
		try container.encodeIfPresent(self.creationTime, forKey: .creationTime)
		try container.encodeIfPresent(self.id, forKey: .id)
		try container.encodeIfPresent(self.`self`, forKey: .`self`)
		try container.encodeIfPresent(self.severity, forKey: .severity)
		try container.encodeIfPresent(self.source, forKey: .source)
		try container.encodeIfPresent(self.text, forKey: .text)
		try container.encodeIfPresent(self.time, forKey: .time)
		try container.encodeIfPresent(self.type, forKey: .type)
		try container.encodeIfPresent(self.user, forKey: .user)
		var additionalContainer = encoder.container(keyedBy: JSONCodingKeys.self)
		for (typeName, encoder) in C8yAuditRecord.encoders {
			if let property = self.customProperties?[typeName] {
				try encoder(property, &additionalContainer)
			}
		}
	}

	/// Summary of the action that was carried out.
	public var activity: String?

	/// Name of the application that performed the action.
	public var application: String?

	/// Metadata of the audit record.
	public var c8yMetadata: C8yMetadata?

	/// Collection of objects describing the changes that were carried out.
	public var changes: [C8yChanges]?

	/// The date and time when the audit record was created.
	public var creationTime: String?

	/// Unique identifier of the audit record.
	public var id: String?

	/// A URL linking to this resource.
	public var `self`: String?

	/// The severity of the audit action.
	public var severity: C8yAuditSeverity?

	/// The managed object to which the audit is associated.
	public var source: C8yAuditSource?

	/// Details of the action that was carried out.
	public var text: String?

	/// The date and time when the audit is updated.
	public var time: String?

	/// Identifies the platform component of the audit.
	public var type: C8yAuditType?

	/// The user who carried out the activity.
	public var user: String?

	/// It is possible to add an arbitrary number of additional properties as a list of key-value pairs, e.g. `"property1": {}`, `"property2": "value"`. These properties can be of any type, e.g. object, string.
	/// 
	public var customProperties: [String: Any]? = [:]

	enum CodingKeys: String, CodingKey {
		case activity
		case application
		case c8yMetadata = "c8y_Metadata"
		case changes
		case creationTime
		case id
		case `self` = "self"
		case severity
		case source
		case text
		case time
		case type
		case user
		case customProperties
	}

	public init() {
	}

	/// The severity of the audit action.
	public enum C8yAuditSeverity: String, Codable {
		case critical = "CRITICAL"
		case major = "MAJOR"
		case minor = "MINOR"
		case warning = "WARNING"
		case information = "INFORMATION"
	}

	/// Identifies the platform component of the audit.
	public enum C8yAuditType: String, Codable {
		case alarm = "Alarm"
		case application = "Application"
		case bulkoperation = "BulkOperation"
		case cepmodule = "CepModule"
		case connector = "Connector"
		case event = "Event"
		case group = "Group"
		case inventory = "Inventory"
		case inventoryrole = "InventoryRole"
		case operation = "Operation"
		case option = "Option"
		case report = "Report"
		case singlesignon = "SingleSignOn"
		case smartrule = "SmartRule"
		case system = "SYSTEM"
		case tenant = "Tenant"
		case tenantauthconfig = "TenantAuthConfig"
		case trustedcertificates = "TrustedCertificates"
		case user = "User"
		case userauthentication = "UserAuthentication"
	}

	/// Metadata of the audit record.
	public struct C8yMetadata: Codable {
	
		/// The action that was carried out.
		public var action: C8yAction?
	
		enum CodingKeys: String, CodingKey {
			case action
		}
	
		public init() {
		}
	
		/// The action that was carried out.
		public enum C8yAction: String, Codable {
			case subscribe = "SUBSCRIBE"
			case deploy = "DEPLOY"
			case scale = "SCALE"
			case delete = "DELETE"
		}
	}

	public struct C8yChanges: Codable {
		
		public init(from decoder: Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.attribute = try container.decodeIfPresent(String.self, forKey: .attribute)
			self.changeType = try container.decodeIfPresent(C8yChangeType.self, forKey: .changeType)
			self.newValue = try container.decodeAnyIfPresent(forKey: .newValue)
			self.previousValue = try container.decodeAnyIfPresent(forKey: .previousValue)
			self.type = try container.decodeIfPresent(String.self, forKey: .type)
		}
		
		public func encode(to encoder: Encoder) throws {
			var container = encoder.container(keyedBy: CodingKeys.self)
			try container.encodeIfPresent(self.attribute, forKey: .attribute)
			try container.encodeIfPresent(self.changeType, forKey: .changeType)
			try container.encodeAnyIfPresent(self.newValue, forKey: .newValue)
			try container.encodeAnyIfPresent(self.previousValue, forKey: .previousValue)
			try container.encodeIfPresent(self.type, forKey: .type)
		}
	
		/// The attribute that was changed.
		public var attribute: String?
	
		/// The type of change that was carried out.
		public var changeType: C8yChangeType?
	
		/// The new value of the object.
		public var newValue: Any?
	
		/// The previous value of the object.
		public var previousValue: Any?
	
		/// The type of the object.
		public var type: String?
	
		enum CodingKeys: String, CodingKey {
			case attribute
			case changeType
			case newValue
			case previousValue
			case type
		}
	
		public init() {
		}
	
		/// The type of change that was carried out.
		public enum C8yChangeType: String, Codable {
			case added = "ADDED"
			case replaced = "REPLACED"
		}
	}

	/// The managed object to which the audit is associated.
	public struct C8yAuditSource: Codable {
	
		/// Unique identifier of the object.
		public var id: String?
	
		/// A URL linking to this resource.
		public var `self`: String?
	
		enum CodingKeys: String, CodingKey {
			case id
			case `self` = "self"
		}
	
		public init() {
		}
	}
}

extension C8yAuditRecord {

    private typealias PropertyDecoder = (KeyedDecodingContainer<JSONCodingKeys>) throws -> Any?
    private typealias PropertyEncoder = (Any, inout KeyedEncodingContainer<JSONCodingKeys>) throws -> Void
    private static var decoders: [String: PropertyDecoder] = [:]
    private static var encoders: [String: PropertyEncoder] = [:]

    public static func registerAdditionalProperty<C: Codable>(typeName: String, for type: C.Type) {
        decoders[typeName] = { container in
            guard let codingKey = JSONCodingKeys(stringValue: typeName) else {
                return nil
            }
            return try? container.decodeIfPresent(C.self, forKey: codingKey)
        }
        encoders[typeName] = { object, container in
			if let codingKey = JSONCodingKeys(stringValue: typeName) {
				if let value = object as? C {
					try container.encode(value, forKey: codingKey)
				}
			}
		}
    }
}
