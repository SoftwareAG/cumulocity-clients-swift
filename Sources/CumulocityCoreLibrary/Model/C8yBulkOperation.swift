//
// C8yBulkOperation.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yBulkOperation: Codable {

	/// A URL linking to this resource.
	public var `self`: String?

	/// Unique identifier of this bulk operation.
	public var id: String?

	/// Identifies the target group on which this operation should be performed.
	/// 
	/// > **ⓘ Note** `groupId` and `failedParentId` are mutually exclusive. Use only one of them in your request.
	public var groupId: String?

	/// Identifies the failed bulk operation from which the failed operations should be rescheduled.
	/// 
	/// > **ⓘ Note** `groupId` and `failedParentId` are mutually exclusive. Use only one of them in your request.
	public var failedParentId: String?

	/// Date and time when the operations of this bulk operation should be created.
	public var startDate: String?

	/// Delay between every operation creation in seconds.
	public var creationRamp: Double?

	/// Operation to be executed for every device in a group.
	public var operationPrototype: C8yOperationPrototype?

	/// The status of this bulk operation, in context of the execution of all its single operations.
	public var status: C8yStatus?

	/// The general status of this bulk operation. The general status is visible for end users and they can filter and evaluate bulk operations by this status.
	public var generalStatus: C8yGeneralStatus?

	/// Contains information about the number of processed operations.
	public var progress: C8yProgress?

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

	/// The status of this bulk operation, in context of the execution of all its single operations.
	public enum C8yStatus: String, Codable {
		case active = "ACTIVE"
		case inprogress = "IN_PROGRESS"
		case completed = "COMPLETED"
		case deleted = "DELETED"
	}

	/// The general status of this bulk operation. The general status is visible for end users and they can filter and evaluate bulk operations by this status.
	public enum C8yGeneralStatus: String, Codable {
		case scheduled = "SCHEDULED"
		case executing = "EXECUTING"
		case executingwitherrors = "EXECUTING_WITH_ERRORS"
		case successful = "SUCCESSFUL"
		case failed = "FAILED"
		case canceled = "CANCELED"
	}

	/// Operation to be executed for every device in a group.
	public struct C8yOperationPrototype: Codable {
	
		public init() {
		}
	}



	/// Contains information about the number of processed operations.
	public struct C8yProgress: Codable {
	
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
}
