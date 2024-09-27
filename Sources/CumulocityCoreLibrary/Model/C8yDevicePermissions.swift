//
// C8yDevicePermissions.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// An object with a list of the user's device permissions.
public struct C8yDevicePermissions: Codable {
	 
	public init(from decoder: Decoder) throws {
		if let additionalContainer = try? decoder.container(keyedBy: JSONCodingKeys.self) {
			for key in additionalContainer.allKeys {
				if let value = try? additionalContainer.decode([String].self, forKey: key) {
			    	self.additionalProperties[key.stringValue] = value
			    }
			}
		}
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try? container.encodeIfPresent(self.additionalProperties, forKey: .additionalProperties)
	}

	public var additionalProperties: [String: [String]] = [:]
	
	public subscript(key: String) -> [String]? {
	        get {
	            return additionalProperties[key]
	        }
	        set(newValue) {
	            additionalProperties[key] = newValue
	        }
	    }

	enum CodingKeys: String, CodingKey {
		case additionalProperties
	}

	public init() {
	}
}
