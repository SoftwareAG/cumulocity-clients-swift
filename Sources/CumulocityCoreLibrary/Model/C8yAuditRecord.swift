//
// C8yAuditRecord.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yAuditRecord: Codable {

	/// Summary of the action that was carried out.
	public var activity: String?

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

	/// The user whom carried out the activity.
	public var user: String?

	enum CodingKeys: String, CodingKey {
		case activity
		case creationTime
		case id
		case `self` = "self"
		case severity
		case source
		case text
		case time
		case type
		case user
	}

	public init() {
	}
}
