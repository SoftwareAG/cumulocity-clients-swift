//
// C8yBulkOperation.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yBulkOperation: Codable {

	/// A URL linking to this resource.
	public var `self`: String?

	/// Unique identifier of this bulk operation.
	public var id: String?

	/// Identifies the target group on which this operation should be performed.
	public var groupId: String?

	/// Identifies the failed bulk operation from which the failed operations should be rescheduled.
	public var failedParentId: String?

	/// Date and time when the operations of this bulk operation should be created.
	public var startDate: String?

	/// Delay between every operation creation in seconds.
	public var creationRamp: Double?

	/// Operation to be executed for every device in a group.
	public var operationPrototype: C8yBulkOperationPrototype?

	/// The status of this bulk operation, in context of the execution of all its single operations.
	public var status: C8yBulkOperationStatus?

	/// The general status of this bulk operation. The general status is visible for end users and they can filter and evaluate bulk operations by this status.
	public var generalStatus: C8yBulkOperationGeneralStatus?

	/// Contains information about the number of processed operations.
	public var progress: C8yBulkOperationProgress?

	enum CodingKeys: String, CodingKey {
		case `self` = "self"
		case id
		case groupId
		case failedParentId
		case startDate
		case creationRamp
		case operationPrototype
		case status
		case generalStatus
		case progress
	}

	public init() {
	}
}
