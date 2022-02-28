//
// C8yUsageStatisticsResourcesUsedBy.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yUsageStatisticsResourcesUsedBy: Codable {

	/// Name of the microservice.
	public var name: String?

	/// Number of CPU usage for a single microservice.
	public var cpu: Int?

	/// Number of memory usage for a single microservice.
	public var memory: Int?

	/// Reason for calculating statistics of the specified microservice.
	public var cause: String?

	enum CodingKeys: String, CodingKey {
		case name
		case cpu
		case memory
		case cause
	}

	public init() {
	}
}
