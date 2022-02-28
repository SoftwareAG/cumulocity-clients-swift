//
// C8yAuditApiResource.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yAuditApiResource: Codable {

	/// Collection of audit records
	public var auditRecords: C8yAuditRecords?

	/// Read-only collection of audit records for a specific application. The placeholder {application} must be the name of a registered application.
	public var auditRecordsForApplication: String?

	/// Read-only collection of audit records for a specific type.
	public var auditRecordsForType: String?

	/// Read-only collection of audit records for a specific user. The placeholder {user} must be a username of a registered user.
	public var auditRecordsForUser: String?

	/// Read-only collection of audit records for specific type and application.
	public var auditRecordsForTypeAndApplication: String?

	/// Read-only collection of audit records for specific type, user and application.
	public var auditRecordsForTypeAndUserAndApplication: String?

	/// Read-only collection of audit records for specific user and application.
	public var auditRecordsForUserAndApplication: String?

	/// Read-only collection of audit records for specific user and type.
	public var auditRecordsForUserAndType: String?

	/// A URL linking to this resource.
	public var `self`: String?

	enum CodingKeys: String, CodingKey {
		case auditRecords
		case auditRecordsForApplication
		case auditRecordsForType
		case auditRecordsForUser
		case auditRecordsForTypeAndApplication
		case auditRecordsForTypeAndUserAndApplication
		case auditRecordsForUserAndApplication
		case auditRecordsForUserAndType
		case `self` = "self"
	}

	public init() {
	}

	/// Collection of audit records
	public struct C8yAuditRecords: Codable {
	
		/// A URL linking to this resource.
		public var `self`: String?
	
		public var auditRecords: [C8yAuditRecord]?
	
		enum CodingKeys: String, CodingKey {
			case `self` = "self"
			case auditRecords
		}
	
		public init() {
		}
	}
}
