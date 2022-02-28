//
// C8yRetentionRule.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yRetentionRule: Codable {

	/// The data type(s) to which the rule is applied.
	public var dataType: C8yDescRetentionRuleDataType?

	/// Indicates whether the rule is editable or not. It can be updated only by the management tenant.
	public var editable: Bool?

	/// The fragment type(s) to which the rule is applied. Used by the data types EVENT, MEASUREMENT, OPERATION and BULK_OPERATION.
	public var fragmentType: String?

	/// Unique identifier of the retention rule.
	public var id: String?

	/// Maximum age expressed in number of days.
	public var maximumAge: Int?

	/// A URL linking to this resource.
	public var `self`: String?

	/// The source(s) to which the rule is applied. Used by all data types.
	public var source: String?

	/// The type(s) to which the rule is applied. Used by the data types ALARM, AUDIT, EVENT and MEASUREMENT.
	public var type: String?

	enum CodingKeys: String, CodingKey {
		case dataType
		case editable
		case fragmentType
		case id
		case maximumAge
		case `self` = "self"
		case source
		case type
	}

	public init() {
	}
}
