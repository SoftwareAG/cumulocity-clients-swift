//
// C8yBulkNewDeviceRequest.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yBulkNewDeviceRequest: Codable {

	/// Number of lines processed from the CSV file, without the first line (column headers).
	public var numberOfAll: Int?

	/// Number of created device credentials.
	public var numberOfCreated: Int?

	/// Number of failed creations of device credentials.
	public var numberOfFailed: Int?

	/// Number of successful creations of device credentials. This counts both create and update operations.
	public var numberOfSuccessful: Int?

	/// An array with the updated device credentials.
	public var credentialUpdatedList: [C8yCredentialUpdatedList]?

	/// An array with the updated device credentials.
	public var failedCreationList: [C8yFailedCreationList]?

	enum CodingKeys: String, CodingKey {
		case numberOfAll
		case numberOfCreated
		case numberOfFailed
		case numberOfSuccessful
		case credentialUpdatedList
		case failedCreationList
	}

	public init() {
	}

	public struct C8yCredentialUpdatedList: Codable {
	
		/// The device credentials creation status.
		public var bulkNewDeviceStatus: C8yNewDeviceStatus?
	
		/// Unique identifier of the device.
		public var deviceId: String?
	
		enum CodingKeys: String, CodingKey {
			case bulkNewDeviceStatus
			case deviceId
		}
	
		public init() {
		}
	}

	public struct C8yFailedCreationList: Codable {
	
		/// The device credentials creation status.
		public var bulkNewDeviceStatus: C8yNewDeviceStatus?
	
		/// Unique identifier of the device.
		public var deviceId: String?
	
		/// Reason for the failure.
		public var failureReason: String?
	
		/// Line where the failure occurred.
		public var line: String?
	
		enum CodingKeys: String, CodingKey {
			case bulkNewDeviceStatus
			case deviceId
			case failureReason
			case line
		}
	
		public init() {
		}
	}
}
