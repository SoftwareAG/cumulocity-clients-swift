//
// C8yBulkOperationProgress.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// Contains information about the number of processed operations.
public struct C8yBulkOperationProgress: Codable {

	/// Number of pending operations.
	public var pending: Int?

	/// Number of failed operations.
	public var failed: Int?

	/// Number of operations being executed.
	public var executing: Int?

	/// Number of operations successfully processed.
	public var successful: Int?

	/// Total number of processed operations.
	public var all: Int?

	enum CodingKeys: String, CodingKey {
		case pending
		case failed
		case executing
		case successful
		case all
	}

	public init() {
	}
}
