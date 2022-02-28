//
// C8ySystemOption.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// A tuple storing tenant configuration.
public struct C8ySystemOption: Codable {

	/// Name of the system option category.
	public var category: String?

	/// A unique identifier for this system option.
	public var key: String?

	/// Value of this system option.
	public var value: String?

	enum CodingKeys: String, CodingKey {
		case category
		case key
		case value
	}

	public init() {
	}
}
