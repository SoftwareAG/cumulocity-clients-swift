//
// C8yUsageStatisticsResourcesUsedBy.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yUsageStatisticsResourcesUsedBy: Codable {

	/// Reason for calculating statistics of the specified microservice.
	public var cause: String?

	/// Number of CPU usage for a single microservice.
	public var cpu: Int?

	/// Number of memory usage for a single microservice.
	public var memory: Int?

	/// Name of the microservice.
	public var name: String?

	enum CodingKeys: String, CodingKey {
		case cause
		case cpu
		case memory
		case name
	}

	public init() {
	}
}
