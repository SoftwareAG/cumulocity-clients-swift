//
// C8yAlarm.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yAlarm: Codable {
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.count = try container.decodeIfPresent(Int.self, forKey: .count)
		self.creationTime = try container.decodeIfPresent(String.self, forKey: .creationTime)
		self.firstOccurrenceTime = try container.decodeIfPresent(String.self, forKey: .firstOccurrenceTime)
		self.id = try container.decodeIfPresent(String.self, forKey: .id)
		self.lastUpdated = try container.decodeIfPresent(String.self, forKey: .lastUpdated)
		self.`self` = try container.decodeIfPresent(String.self, forKey: .`self`)
		self.severity = try container.decodeIfPresent(C8ySeverity.self, forKey: .severity)
		self.source = try container.decodeIfPresent(C8ySource.self, forKey: .source)
		self.status = try container.decodeIfPresent(C8yStatus.self, forKey: .status)
		self.text = try container.decodeIfPresent(String.self, forKey: .text)
		self.time = try container.decodeIfPresent(String.self, forKey: .time)
		self.type = try container.decodeIfPresent(String.self, forKey: .type)
		if let additionalContainer = try? decoder.container(keyedBy: JSONCodingKeys.self) {
			for (typeName, decoder) in C8yAlarm.decoders {
				self.customFragments[typeName] = try? decoder(additionalContainer)
			}
		}
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(self.count, forKey: .count)
		try container.encodeIfPresent(self.creationTime, forKey: .creationTime)
		try container.encodeIfPresent(self.firstOccurrenceTime, forKey: .firstOccurrenceTime)
		try container.encodeIfPresent(self.id, forKey: .id)
		try container.encodeIfPresent(self.lastUpdated, forKey: .lastUpdated)
		try container.encodeIfPresent(self.`self`, forKey: .`self`)
		try container.encodeIfPresent(self.severity, forKey: .severity)
		try container.encodeIfPresent(self.source, forKey: .source)
		try container.encodeIfPresent(self.status, forKey: .status)
		try container.encodeIfPresent(self.text, forKey: .text)
		try container.encodeIfPresent(self.time, forKey: .time)
		try container.encodeIfPresent(self.type, forKey: .type)
		var additionalContainer = encoder.container(keyedBy: JSONCodingKeys.self)
		for (typeName, encoder) in C8yAlarm.encoders {
			if let property = self.customFragments[typeName] {
				try encoder(property, &additionalContainer)
			}
		}
	}

	/// Number of times that this alarm has been triggered.
	public var count: Int?

	/// The date and time when the alarm was created.
	public var creationTime: String?

	/// The time at which the alarm occurred for the first time. Only present when `count` is greater than 1.
	public var firstOccurrenceTime: String?

	/// Unique identifier of the alarm.
	public var id: String?

	/// The date and time when the alarm was last updated.
	public var lastUpdated: String?

	/// A URL linking to this resource.
	public var `self`: String?

	/// The severity of the alarm.
	public var severity: C8ySeverity?

	/// The managed object to which the alarm is associated.
	public var source: C8ySource?

	/// The status of the alarm. If not specified, a new alarm will be created as ACTIVE.
	public var status: C8yStatus?

	/// Description of the alarm.
	public var text: String?

	/// The date and time when the alarm is triggered.
	public var time: String?

	/// Identifies the type of this alarm.
	public var type: String?

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
		case count
		case creationTime
		case firstOccurrenceTime
		case id
		case lastUpdated
		case `self` = "self"
		case severity
		case source
		case status
		case text
		case time
		case type
		case customFragments
	}

	public init() {
	}

	/// The severity of the alarm.
	public enum C8ySeverity: String, Codable {
		case critical = "CRITICAL"
		case major = "MAJOR"
		case minor = "MINOR"
		case warning = "WARNING"
	}

	/// The status of the alarm. If not specified, a new alarm will be created as ACTIVE.
	public enum C8yStatus: String, Codable {
		case active = "ACTIVE"
		case acknowledged = "ACKNOWLEDGED"
		case cleared = "CLEARED"
	}


	/// The managed object to which the alarm is associated.
	public struct C8ySource: Codable {
	
		/// Unique identifier of the object.
		public var id: String?
	
		/// Human-readable name that is used for representing the object in user interfaces.
		public var name: String?
	
		/// A URL linking to this resource.
		public var `self`: String?
	
		enum CodingKeys: String, CodingKey {
			case id
			case name
			case `self` = "self"
		}
	
		public init() {
		}
	}

}

extension C8yAlarm {

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
