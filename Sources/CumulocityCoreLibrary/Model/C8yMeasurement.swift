//
// C8yMeasurement.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yMeasurement: Codable {
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decodeIfPresent(String.self, forKey: .id)
		self.`self` = try container.decodeIfPresent(String.self, forKey: .`self`)
		self.source = try container.decodeIfPresent(C8ySource.self, forKey: .source)
		self.time = try container.decodeIfPresent(String.self, forKey: .time)
		self.type = try container.decodeIfPresent(String.self, forKey: .type)
		self.c8ySteam = try container.decodeIfPresent(C8ySteam.self, forKey: .c8ySteam)
		if let additionalContainer = try? decoder.container(keyedBy: JSONCodingKeys.self) {
			for (typeName, decoder) in C8yMeasurement.decoders {
				self.customFragments[typeName] = try? decoder(additionalContainer)
			}
		}
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(self.id, forKey: .id)
		try container.encodeIfPresent(self.`self`, forKey: .`self`)
		try container.encodeIfPresent(self.source, forKey: .source)
		try container.encodeIfPresent(self.time, forKey: .time)
		try container.encodeIfPresent(self.type, forKey: .type)
		try container.encodeIfPresent(self.c8ySteam, forKey: .c8ySteam)
		var additionalContainer = encoder.container(keyedBy: JSONCodingKeys.self)
		for (typeName, encoder) in C8yMeasurement.encoders {
			if let property = self.customFragments[typeName] {
				try encoder(property, &additionalContainer)
			}
		}
	}

	/// Unique identifier of the measurement.
	public var id: String?

	/// A URL linking to this resource.
	public var `self`: String?

	/// The managed object to which the measurement is associated.
	public var source: C8ySource?

	/// The date and time when the measurement is created.
	public var time: String?

	/// Identifies the type of this measurement.
	public var type: String?

	/// A type of measurement fragment.
	public var c8ySteam: C8ySteam?

	/// It is possible to add an arbitrary number of additional properties as a list of key-value pairs, for example, `"property1": {}`, `"property2": "value"`. These properties are known as custom fragments and can be of any type, for example, object or string. Each custom fragment is identified by a unique name.
	/// 
	/// Review the [Naming conventions of fragments](https://cumulocity.com/guides/concepts/domain-model/#naming-conventions-of-fragments) as there are characters that can not be used when naming custom fragments.
	/// 
	public var customFragments: [String: Any] = [:]
	
	public subscript(key: String) -> Any? {
	        get {
	            return customFragments[key]
	        }
	        set(newValue) {
	            customFragments[key] = newValue
	        }
	    }

	enum CodingKeys: String, CodingKey {
		case id
		case `self` = "self"
		case source
		case time
		case type
		case c8ySteam = "c8y_Steam"
		case customFragments
	}

	public init(source: C8ySource, time: String, type: String) {
		self.source = source
		self.time = time
		self.type = type
	}

	/// The managed object to which the measurement is associated.
	public struct C8ySource: Codable {
	
		/// Unique identifier of the object.
		public var id: String?
	
		/// A URL linking to this resource.
		public var `self`: String?
	
		enum CodingKeys: String, CodingKey {
			case id
			case `self` = "self"
		}
	
		public init(id: String) {
			self.id = id
		}
	}
}

extension C8yMeasurement {

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
