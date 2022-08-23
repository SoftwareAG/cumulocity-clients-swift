//
// C8yManagedObject.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yManagedObject: Codable {
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.creationTime = try container.decodeIfPresent(String.self, forKey: .creationTime)
		self.id = try container.decodeIfPresent(String.self, forKey: .id)
		self.lastUpdated = try container.decodeIfPresent(String.self, forKey: .lastUpdated)
		self.name = try container.decodeIfPresent(String.self, forKey: .name)
		self.owner = try container.decodeIfPresent(String.self, forKey: .owner)
		self.`self` = try container.decodeIfPresent(String.self, forKey: .`self`)
		self.type = try container.decodeIfPresent(String.self, forKey: .type)
		self.childAdditions = try container.decodeIfPresent(C8yObjectChildAdditions.self, forKey: .childAdditions)
		self.childAssets = try container.decodeIfPresent(C8yObjectChildAssets.self, forKey: .childAssets)
		self.childDevices = try container.decodeIfPresent(C8yObjectChildDevices.self, forKey: .childDevices)
		self.additionParents = try container.decodeIfPresent(C8yObjectAdditionParents.self, forKey: .additionParents)
		self.assetParents = try container.decodeIfPresent(C8yObjectAssetParents.self, forKey: .assetParents)
		self.deviceParents = try container.decodeIfPresent(C8yObjectDeviceParents.self, forKey: .deviceParents)
		self.c8yIsDevice = try container.decodeIfPresent(C8yIsDevice.self, forKey: .c8yIsDevice)
		self.c8yDeviceTypes = try container.decodeIfPresent([String].self, forKey: .c8yDeviceTypes)
		self.c8ySupportedOperations = try container.decodeIfPresent([String].self, forKey: .c8ySupportedOperations)
		if let additionalContainer = try? decoder.container(keyedBy: JSONCodingKeys.self) {
			for (typeName, decoder) in C8yManagedObject.decoders {
				self.customFragments?[typeName] = try? decoder(additionalContainer)
			}
		}
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(self.creationTime, forKey: .creationTime)
		try container.encodeIfPresent(self.id, forKey: .id)
		try container.encodeIfPresent(self.lastUpdated, forKey: .lastUpdated)
		try container.encodeIfPresent(self.name, forKey: .name)
		try container.encodeIfPresent(self.owner, forKey: .owner)
		try container.encodeIfPresent(self.`self`, forKey: .`self`)
		try container.encodeIfPresent(self.type, forKey: .type)
		try container.encodeIfPresent(self.childAdditions, forKey: .childAdditions)
		try container.encodeIfPresent(self.childAssets, forKey: .childAssets)
		try container.encodeIfPresent(self.childDevices, forKey: .childDevices)
		try container.encodeIfPresent(self.additionParents, forKey: .additionParents)
		try container.encodeIfPresent(self.assetParents, forKey: .assetParents)
		try container.encodeIfPresent(self.deviceParents, forKey: .deviceParents)
		try container.encodeIfPresent(self.c8yIsDevice, forKey: .c8yIsDevice)
		try container.encodeIfPresent(self.c8yDeviceTypes, forKey: .c8yDeviceTypes)
		try container.encodeIfPresent(self.c8ySupportedOperations, forKey: .c8ySupportedOperations)
		var additionalContainer = encoder.container(keyedBy: JSONCodingKeys.self)
		for (typeName, encoder) in C8yManagedObject.encoders {
			if let property = self.customFragments?[typeName] {
				try encoder(property, &additionalContainer)
			}
		}
	}

	/// The date and time when the object was created.
	public var creationTime: String?

	/// Unique identifier of the object.
	public var id: String?

	/// The date and time when the object was updated for the last time.
	public var lastUpdated: String?

	/// Human-readable name that is used for representing the object in user interfaces.
	public var name: String?

	/// Username of the device's owner.
	public var owner: String?

	/// A URL linking to this resource.
	public var `self`: String?

	/// The fragment type can be interpreted as _device class_, this means, devices with the same type can receive the same types of configuration, software, firmware and operations. The type value is indexed and is therefore used for queries.
	public var type: String?

	/// A collection of references to child additions.
	public var childAdditions: C8yObjectChildAdditions?

	/// A collection of references to child assets.
	public var childAssets: C8yObjectChildAssets?

	/// A collection of references to child devices.
	public var childDevices: C8yObjectChildDevices?

	/// A collection of references to addition parent objects.
	public var additionParents: C8yObjectAdditionParents?

	/// A collection of references to asset parent objects.
	public var assetParents: C8yObjectAssetParents?

	/// A collection of references to device parent objects.
	public var deviceParents: C8yObjectDeviceParents?

	/// A fragment which identifies this managed object as a device.
	public var c8yIsDevice: C8yIsDevice?

	/// This fragment must be added in order to publish sample commands for a subset of devices sharing the same device type. If the fragment is present, the list of sample commands for a device type will be extended with the sample commands for the `c8y_DeviceTypes`. New sample commands created from the user interface will be created in the context of the `c8y_DeviceTypes`.
	public var c8yDeviceTypes: [String]?

	/// Lists the operations that are available for a particular device, so that applications can trigger the operations.
	public var c8ySupportedOperations: [String]?

	/// It is possible to add an arbitrary number of additional properties as a list of key-value pairs, for example, `"property1": {}`, `"property2": "value"`. These properties are known as custom fragments and can be of any type, for example, object or string. Each custom fragment is identified by a unique name.
	/// 
	/// Review the [Naming conventions of fragments](https://cumulocity.com/guides/concepts/domain-model/#naming-conventions-of-fragments) as there are characters that can not be used when naming custom fragments.
	/// 
	public var customFragments: [String: Any]? = [:]

	enum CodingKeys: String, CodingKey {
		case creationTime
		case id
		case lastUpdated
		case name
		case owner
		case `self` = "self"
		case type
		case childAdditions
		case childAssets
		case childDevices
		case additionParents
		case assetParents
		case deviceParents
		case c8yIsDevice = "c8y_IsDevice"
		case c8yDeviceTypes = "c8y_DeviceTypes"
		case c8ySupportedOperations = "c8y_SupportedOperations"
		case customFragments
	}

	public init() {
	}

	/// A fragment which identifies this managed object as a device.
	public struct C8yIsDevice: Codable {
	
		public init() {
		}
	}
}

extension C8yManagedObject {

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
