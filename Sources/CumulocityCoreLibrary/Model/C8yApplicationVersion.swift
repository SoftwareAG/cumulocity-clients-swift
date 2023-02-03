//
// C8yApplicationVersion.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yApplicationVersion: Codable {

	/// Unique identifier of the version.
	public var version: String?

	/// Unique identifier of the binary file assigned to the version.
	public var binaryId: String?

	/// Tag assigned to the version. Version tags must be unique across all versions and version fields of application versions.
	public var tag: [String]?

	enum CodingKeys: String, CodingKey {
		case version
		case binaryId
		case tag
	}

	public init() {
	}
}
