//
// C8yBulkOperationGeneralStatus.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// The general status of this bulk operation. The general status is visible for end users and they can filter and evaluate bulk operations by this status.
public enum C8yBulkOperationGeneralStatus: String, Codable {
	case scheduled = "SCHEDULED"
	case executing = "EXECUTING"
	case executing_with_errors = "EXECUTING_WITH_ERRORS"
	case successful = "SUCCESSFUL"
	case failed = "FAILED"
	case canceled = "CANCELED"
}
