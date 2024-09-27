//
// C8yCategoryOptions.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yCategoryOptions: Codable {
	 
	public init(from decoder: Decoder) throws {
		if let additionalContainer = try? decoder.container(keyedBy: JSONCodingKeys.self) {
			for (typeName, decoder) in C8yCategoryOptions.decoders {
				self.keyValuePairs[typeName] = try? decoder(additionalContainer)
			}
		}
	}
	
	public func encode(to encoder: Encoder) throws {
		var additionalContainer = encoder.container(keyedBy: JSONCodingKeys.self)
		for (typeName, encoder) in C8yCategoryOptions.encoders {
			if let property = self.keyValuePairs[typeName] {
				try encoder(property, &additionalContainer)
			}
		}
	}

	/// It is possible to specify an arbitrary number of existing options as a list of key-value pairs, for example, `"key1": "value1"`, `"key2": "value2"`.
	public var keyValuePairs: [String: Any] = [:]
	
	public subscript(key: String) -> Any? {
	        get {
	            return keyValuePairs[key]
	        }
	        set(newValue) {
	            keyValuePairs[key] = newValue
	        }
	    }

	enum CodingKeys: String, CodingKey {
		case keyValuePairs
	}

	public init() {
	}
}

extension C8yCategoryOptions {

    private typealias PropertyDecoder = (KeyedDecodingContainer<JSONCodingKeys>) throws -> Any?
    private typealias PropertyEncoder = (Any, inout KeyedEncodingContainer<JSONCodingKeys>) throws -> Void
    private static var decoders: [String: PropertyDecoder] = [:]
    private static var encoders: [String: PropertyEncoder] = [:]

	public static func registerAdditionalProperty(typeName: String) {
		decoders[typeName] = { container in
			guard let codingKey = JSONCodingKeys(stringValue: typeName) else {
				return nil
			}
			return try? container.decodeAnyIfPresent(forKey: codingKey)
        }
		encoders[typeName] = { object, container in
			if let codingKey = JSONCodingKeys(stringValue: typeName) {
				try container.encodeAnyIfPresent(object, forKey: codingKey)
			}
		}
	}

    public static func registerAdditionalProperty<C: Codable>(typeName: String, for type: C.Type) {
        decoders[typeName] = { container in
            guard let codingKey = JSONCodingKeys(stringValue: typeName) else {
                return nil
            }
            return try? container.decodeIfPresent(C.self, forKey: codingKey)
        }
        encoders[typeName] = { object, container in
			if let codingKey = JSONCodingKeys(stringValue: typeName) {
				if let value = object as? C {
					try container.encode(value, forKey: codingKey)
				}
			}
		}
    }
}
