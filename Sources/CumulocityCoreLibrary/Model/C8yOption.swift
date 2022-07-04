//
// C8yOption.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// A tuple storing tenant configuration.
public struct C8yOption: Codable {

	/// Name of the option category.
	public var category: String?

	/// A unique identifier for this option.
	public var key: String?

	/// Value of this option.
	public var value: String?

	/// A URL linking to this resource.
	public var `self`: String?

	enum CodingKeys: String, CodingKey {
		case category
		case key
		case value
		case `self` = "self"
	}

	public init() {
	}
}
