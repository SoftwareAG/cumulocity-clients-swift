//
// C8yOperation.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yOperation: Codable {
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.`self` = try container.decodeIfPresent(String.self, forKey: .`self`)
		self.id = try container.decodeIfPresent(String.self, forKey: .id)
		self.creationTime = try container.decodeIfPresent(String.self, forKey: .creationTime)
		self.deviceId = try container.decodeIfPresent(String.self, forKey: .deviceId)
		self.deviceExternalIDs = try container.decodeIfPresent(C8yExternalIds.self, forKey: .deviceExternalIDs)
		self.bulkOperationId = try container.decodeIfPresent(String.self, forKey: .bulkOperationId)
		self.status = try container.decodeIfPresent(C8yOperationStatus.self, forKey: .status)
		self.failureReason = try container.decodeIfPresent(String.self, forKey: .failureReason)
		self.comCumulocityModelWebCamDevice = try container.decodeIfPresent(C8yWebCamDevice.self, forKey: .comCumulocityModelWebCamDevice)
		if let additionalContainer = try? decoder.container(keyedBy: JSONCodingKeys.self) {
			for (typeName, decoder) in C8yOperation.decoders {
				self.customFragments?[typeName] = try? decoder(additionalContainer)
			}
		}
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(self.`self`, forKey: .`self`)
		try container.encodeIfPresent(self.id, forKey: .id)
		try container.encodeIfPresent(self.creationTime, forKey: .creationTime)
		try container.encodeIfPresent(self.deviceId, forKey: .deviceId)
		try container.encodeIfPresent(self.deviceExternalIDs, forKey: .deviceExternalIDs)
		try container.encodeIfPresent(self.bulkOperationId, forKey: .bulkOperationId)
		try container.encodeIfPresent(self.status, forKey: .status)
		try container.encodeIfPresent(self.failureReason, forKey: .failureReason)
		try container.encodeIfPresent(self.comCumulocityModelWebCamDevice, forKey: .comCumulocityModelWebCamDevice)
		var additionalContainer = encoder.container(keyedBy: JSONCodingKeys.self)
		for (typeName, encoder) in C8yOperation.encoders {
			if let property = self.customFragments?[typeName] {
				try encoder(property, &additionalContainer)
			}
		}
	}

	/// A URL linking to this resource.
	public var `self`: String?

	/// Unique identifier of this operation.
	public var id: String?

	/// Date and time when the operation was created in the database.
	public var creationTime: String?

	/// Identifier of the target device where the operation should be performed.
	public var deviceId: String?

	public var deviceExternalIDs: C8yExternalIds?

	/// Reference to a bulk operation ID if this operation was scheduled from a bulk operation.
	public var bulkOperationId: String?

	/// The status of the operation.
	public var status: C8yOperationStatus?

	/// Reason for the failure.
	public var failureReason: String?

	/// Custom operation of a webcam.
	public var comCumulocityModelWebCamDevice: C8yWebCamDevice?

	/// It is possible to add an arbitrary number of additional properties as a list of key-value pairs, for example, `"property1": {}`, `"property2": "value"`. These properties are known as custom fragments and can be of any type, for example, object or string. Each custom fragment is identified by a unique name.
	/// 
	/// Review the [Naming conventions of fragments](https://cumulocity.com/guides/concepts/domain-model/#naming-conventions-of-fragments) as there are characters that can not be used when naming custom fragments.
	/// 
	public var customFragments: [String: Any]? = [:]

	enum CodingKeys: String, CodingKey {
		case `self` = "self"
		case id
		case creationTime
		case deviceId
		case deviceExternalIDs
		case bulkOperationId
		case status
		case failureReason
		case comCumulocityModelWebCamDevice = "com_cumulocity_model_WebCamDevice"
		case customFragments
	}

	public init() {
	}

	/// Custom operation of a webcam.
	public struct C8yWebCamDevice: Codable {
	
		public init() {
		}
	}
}

extension C8yOperation {

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
