//
// C8yPageStatistics.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// Information about paging statistics.
public struct C8yPageStatistics: Codable {

	/// The current page of the paginated results.
	public var currentPage: Int?

	/// Indicates the number of objects that the collection may contain per page. The upper limit for one page is 2,000 objects.
	public var pageSize: Int?

	/// The total number of results (elements).
	public var totalElements: Int?

	/// The total number of paginated results (pages).
	/// 
	/// > **ⓘ Note** This property is returned by default except when an operation retrieves all records where values are between an upper and lower boundary, for example, querying ranges using `dateFrom`–`dateTo`. In such cases, the query parameter `withTotalPages=true` should be used to include the total number of pages (at the expense of slightly slower performance).
	public var totalPages: Int?

	enum CodingKeys: String, CodingKey {
		case currentPage
		case pageSize
		case totalElements
		case totalPages
	}

	public init() {
	}
}
