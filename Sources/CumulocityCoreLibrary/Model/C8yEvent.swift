//
// C8yEvent.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yEvent: Codable {
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.creationTime = try container.decodeIfPresent(String.self, forKey: .creationTime)
		self.lastUpdated = try container.decodeIfPresent(String.self, forKey: .lastUpdated)
		self.id = try container.decodeIfPresent(String.self, forKey: .id)
		self.`self` = try container.decodeIfPresent(String.self, forKey: .`self`)
		self.source = try container.decodeIfPresent(C8ySource.self, forKey: .source)
		self.text = try container.decodeIfPresent(String.self, forKey: .text)
		self.time = try container.decodeIfPresent(String.self, forKey: .time)
		self.type = try container.decodeIfPresent(String.self, forKey: .type)
		if let additionalContainer = try? decoder.container(keyedBy: JSONCodingKeys.self) {
			for (typeName, decoder) in C8yEvent.decoders {
				self.customFragments?[typeName] = try? decoder(additionalContainer)
			}
		}
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(self.creationTime, forKey: .creationTime)
		try container.encodeIfPresent(self.lastUpdated, forKey: .lastUpdated)
		try container.encodeIfPresent(self.id, forKey: .id)
		try container.encodeIfPresent(self.`self`, forKey: .`self`)
		try container.encodeIfPresent(self.source, forKey: .source)
		try container.encodeIfPresent(self.text, forKey: .text)
		try container.encodeIfPresent(self.time, forKey: .time)
		try container.encodeIfPresent(self.type, forKey: .type)
		var additionalContainer = encoder.container(keyedBy: JSONCodingKeys.self)
		for (typeName, encoder) in C8yEvent.encoders {
			if let property = self.customFragments?[typeName] {
				try encoder(property, &additionalContainer)
			}
		}
	}

	/// The date and time when the event was created.
	public var creationTime: String?

	/// The date and time when the event was last updated.
	public var lastUpdated: String?

	/// Unique identifier of the event.
	public var id: String?

	/// A URL linking to this resource.
	public var `self`: String?

	/// The managed object to which the event is associated.
	public var source: C8ySource?

	/// Description of the event.
	public var text: String?

	/// The date and time when the event is updated.
	public var time: String?

	/// Identifies the type of this event.
	public var type: String?

	/// It is possible to add an arbitrary number of additional properties as a list of key-value pairs, for example, `"property1": {}`, `"property2": "value"`. These properties are known as custom fragments and can be of any type, for example, object or string. Each custom fragment is identified by a unique name.
	/// 
	/// Review the [Naming conventions of fragments](https://cumulocity.com/guides/concepts/domain-model/#naming-conventions-of-fragments) as there are characters that can not be used when naming custom fragments.
	/// 
	public var customFragments: [String: Any]? = [:]

	enum CodingKeys: String, CodingKey {
		case creationTime
		case lastUpdated
		case id
		case `self` = "self"
		case source
		case text
		case time
		case type
		case customFragments
	}

	public init() {
	}

	/// The managed object to which the event is associated.
	public struct C8ySource: Codable {
	
		/// Unique identifier of the object.
		public var id: String?
	
		/// A URL linking to this resource.
		public var `self`: String?
	
		enum CodingKeys: String, CodingKey {
			case id
			case `self` = "self"
		}
	
		public init() {
		}
	}
}

extension C8yEvent {

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
