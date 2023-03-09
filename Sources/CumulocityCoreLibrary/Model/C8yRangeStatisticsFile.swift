//
// C8yRangeStatisticsFile.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yRangeStatisticsFile: Codable {

	/// Statistics generation start date.
	public var dateFrom: String?

	/// Statistics generation end date.
	public var dateTo: String?

	enum CodingKeys: String, CodingKey {
		case dateFrom
		case dateTo
	}

	public init(dateFrom: String, dateTo: String) {
		self.dateFrom = dateFrom
		self.dateTo = dateTo
	}
}
