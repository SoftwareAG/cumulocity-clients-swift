//
// C8yApplicationSettings.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yApplicationSettings: Codable {

	/// The name of the setting.
	public var key: String?

	/// The value schema determines the values that the microservice can process.
	public var valueSchema: C8yValueSchema?

	/// The default value.
	public var defaultValue: String?

	/// Indicates if the value is editable.
	public var editable: Bool?

	/// Indicated wether this setting is inherited.
	public var inheritFromOwner: Bool?

	enum CodingKeys: String, CodingKey {
		case key
		case valueSchema
		case defaultValue
		case editable
		case inheritFromOwner
	}

	public init() {
	}

	/// The value schema determines the values that the microservice can process.
	public struct C8yValueSchema: Codable {
	
		/// The value schema type.
		public var type: String?
	
		enum CodingKeys: String, CodingKey {
			case type
		}
	
		public init() {
		}
	}
}
