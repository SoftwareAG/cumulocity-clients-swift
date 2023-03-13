//
// C8yDeviceControlApiResource.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yDeviceControlApiResource: Codable {

	/// Collection of all operations.
	public var operations: C8yOperations?

	/// Read-only collection of all operations with a particular status.
	public var operationsByStatus: String?

	/// Read-only collection of all operations targeting a particular agent.
	public var operationsByAgentId: String?

	/// Read-only collection of all operations targeting a particular agent and with a particular status.
	public var operationsByAgentIdAndStatus: String?

	/// Read-only collection of all operations to be executed on a particular device.
	public var operationsByDeviceId: String?

	/// Read-only collection of all operations with a particular status, that should be executed on a particular device.
	public var operationsByDeviceIdAndStatus: String?

	/// A URL linking to this resource.
	public var `self`: String?

	enum CodingKeys: String, CodingKey {
		case operations
		case operationsByStatus
		case operationsByAgentId
		case operationsByAgentIdAndStatus
		case operationsByDeviceId
		case operationsByDeviceIdAndStatus
		case `self` = "self"
	}

	public init() {
	}

	/// Collection of all operations.
	public struct C8yOperations: Codable {
	
		/// A URL linking to this resource.
		public var `self`: String?
	
		/// An array containing the registered operations.
		public var operations: [C8yOperationReference]?
	
		enum CodingKeys: String, CodingKey {
			case `self` = "self"
			case operations
		}
	
		public init() {
		}
	}
}
