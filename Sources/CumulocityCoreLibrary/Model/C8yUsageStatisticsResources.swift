//
// C8yUsageStatisticsResources.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// Resources usage for each subscribed microservice application.
public struct C8yUsageStatisticsResources: Codable {

	/// Total number of CPU usage for tenant microservices, specified in CPU milliseconds (1000m = 1 CPU).
	public var cpu: Int?

	/// Total number of memory usage for tenant microservices, specified in MB.
	public var memory: Int?

	/// Collection of resources usage for each microservice.
	public var usedBy: [C8yUsageStatisticsResourcesUsedBy]?

	enum CodingKeys: String, CodingKey {
		case cpu
		case memory
		case usedBy
	}

	public init() {
	}
}
