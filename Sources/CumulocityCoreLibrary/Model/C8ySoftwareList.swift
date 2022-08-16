//
// C8ySoftwareList.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// Details of the installed software.
public struct C8ySoftwareList: Codable {

	/// The name of the software.
	public var name: String?

	/// The version of the software.
	public var version: String?

	/// The URL of the software, for example, its code repository.
	public var url: String?

	enum CodingKeys: String, CodingKey {
		case name
		case version
		case url
	}

	public init() {
	}
}
