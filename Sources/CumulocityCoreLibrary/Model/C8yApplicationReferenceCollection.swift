//
// C8yApplicationReferenceCollection.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yApplicationReferenceCollection: Codable {

	/// A URI reference [[RFC3986](https://tools.ietf.org/html/rfc3986)] to a potential next page of managed objects.
	public var next: String?

	/// A URI reference [[RFC3986](https://tools.ietf.org/html/rfc3986)] to a potential previous page of managed objects.
	public var prev: String?

	/// An array containing all subscribed applications.
	public var references: [C8yApplication]?

	/// A URL linking to this resource.
	public var `self`: String?

	/// Information about paging statistics.
	public var statistics: C8yPageStatistics?

	enum CodingKeys: String, CodingKey {
		case next
		case prev
		case references
		case `self` = "self"
		case statistics
	}

	public init() {
	}
}
