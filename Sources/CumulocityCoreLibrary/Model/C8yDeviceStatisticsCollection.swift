//
// C8yDeviceStatisticsCollection.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// Statistics of the tenant devices.
public struct C8yDeviceStatisticsCollection: Codable {

	/// A URL linking to this resource.
	public var `self`: String?

	/// A URI reference [[RFC3986](https://tools.ietf.org/html/rfc3986)] to a potential next page of managed objects.
	public var next: String?

	/// An array containing the tenant device statistics.
	public var statistics: [C8yDeviceStatistics]?

	enum CodingKeys: String, CodingKey {
		case `self` = "self"
		case next
		case statistics
	}

	public init() {
	}
}
