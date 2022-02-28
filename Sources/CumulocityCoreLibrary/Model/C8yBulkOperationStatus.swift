//
// C8yBulkOperationStatus.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// The status of this bulk operation, in context of the execution of all its single operations.
public enum C8yBulkOperationStatus: String, Codable {
	case active = "ACTIVE"
	case in_progress = "IN_PROGRESS"
	case completed = "COMPLETED"
	case deleted = "DELETED"
}
