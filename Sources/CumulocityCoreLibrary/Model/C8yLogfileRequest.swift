//
// C8yLogfileRequest.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// Request a device to send a log file and view it in Cumulocity IoT's log viewer.
public struct C8yLogfileRequest: Codable {

	/// Indicates the log file to select.
	public var logFile: String?

	/// Start date and time of log entries in the log file to be sent.
	public var dateFrom: String?

	/// End date and time of log entries in the log file to be sent.
	public var dateTo: String?

	/// Provide a text that needs to be present in the log entry.
	public var searchText: String?

	/// Upper limit of the number of lines that should be sent to Cumulocity IoT after filtering.
	public var maximumLines: Int?

	/// A link to the log file request.
	public var file: String?

	enum CodingKeys: String, CodingKey {
		case logFile
		case dateFrom
		case dateTo
		case searchText
		case maximumLines
		case file
	}

	public init() {
	}
}
