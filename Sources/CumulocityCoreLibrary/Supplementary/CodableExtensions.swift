//
// CodableExtensions.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

extension KeyedEncodingContainer {

    public mutating func encodeAnyIfPresent(_ value: Any?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        if let boolValue = value as? Bool {
            try self.encode(boolValue, forKey: key)
        } else if let stringValue = value as? String {
            try self.encode(stringValue, forKey: key)
        } else if let intValue = value as? Int {
            try self.encode(intValue, forKey: key)
        } else if let doublevalue = value as? Double {
            try self.encode(doublevalue, forKey: key)
        } else if let nestedDictionary = value as? [String:Any] {
            try self.encode(nestedDictionary, forKey: key)
        } else if let nestedArray = value as? [Any] {
            try self.encode(nestedArray, forKey: key)
        }
    }

    public mutating func encode(_ value: Dictionary<String, Any>, forKey key: K) throws {
        var container = self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        try container.encode(value)
    }

    public mutating func encode(_ value: Array<Any>, forKey key: K) throws {
        var container = self.nestedUnkeyedContainer(forKey: key)
        try container.encode(value)
    }

    public mutating func encode(_ object: Dictionary<String,Any>) throws {
        for key in object.keys {
            let value = object[key] as Any
            try self.encodeAnyIfPresent(value, forKey: JSONCodingKeys(stringValue: key) as! K)
        }
    }
}

extension UnkeyedEncodingContainer {

    mutating func encode(_ value: Dictionary<String, Any>) throws {
        var nestedContainer = self.nestedContainer(keyedBy: JSONCodingKeys.self)
        try nestedContainer.encode(value)
    }

    mutating func encode(_ object: Array<Any>) throws {
        for value in object {
            if let intValue = value as? Int {
                try? self.encode(intValue)
            } else if let floatValue = value as? Float {
                try? self.encode(floatValue)
            } else if let doubleValue = value as? Double {
                try? self.encode(doubleValue)
            } else if let stringValue = value as? String {
                try? self.encode(stringValue)
            } else if let dateValue = value as? Date {
                try? self.encode(dateValue)
            } else if let boolValue = value as? Bool {
                try? self.encode(boolValue)
            } else if let nestedDictionary = value as? [String:Any] {
                try? self.encode(nestedDictionary)
            } else if let nestedArray = value as? [Any] {
                try? self.encode(nestedArray)
            }
        }
    }
}

extension KeyedDecodingContainer {

    func decodeAnyIfPresent(forKey key: K) throws -> Any? {
        guard contains(key) else {
            return nil
        }
        if let boolValue = try? decode(Bool.self, forKey: key) {
            return boolValue
        } else if let stringValue = try? decode(String.self, forKey: key) {
            return stringValue
        } else if let intValue = try? decode(Int.self, forKey: key) {
            return intValue
        } else if let doubleValue = try? decode(Double.self, forKey: key) {
            return doubleValue
        } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self, forKey: key) {
            return nestedDictionary
        } else if let nestedArray = try? decode(Array<Any>.self, forKey: key) {
            return nestedArray
        }
        return nil
    }

    func decode(_ type: Dictionary<String, Any>.Type, forKey key: K) throws -> Dictionary<String, Any> {
        let container = try self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        return try container.decode(type)
    }

    func decodeIfPresent(_ type: Dictionary<String, Any>.Type, forKey key: K) throws -> Dictionary<String, Any>? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try decode(type, forKey: key)
    }

    func decode(_ type: Array<Any>.Type, forKey key: K) throws -> Array<Any> {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }

    func decodeIfPresent(_ type: Array<Any>.Type, forKey key: K) throws -> Array<Any>? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try decode(type, forKey: key)
    }

    func decode(_ type: Dictionary<String, Any>.Type) throws -> Dictionary<String, Any> {
        var dictionary = Dictionary<String, Any>()

        for key in allKeys {
            if let boolValue = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = boolValue
            } else if let stringValue = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = stringValue
            } else if let intValue = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = intValue
            } else if let doubleValue = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = doubleValue
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedDictionary
            } else if let nestedArray = try? decode(Array<Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedArray
            }
        }
        return dictionary
    }
}

extension UnkeyedDecodingContainer {

    mutating func decode(_ type: Array<Any>.Type) throws -> Array<Any> {
        var array: [Any] = []
        while isAtEnd == false {
            if try decodeNil() {
                continue
            } else if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self) {
                array.append(nestedDictionary)
            } else if let nestedArray = try? decode(Array<Any>.self) {
                array.append(nestedArray)
            }
        }
        return array
    }

    mutating func decode(_ type: Dictionary<String, Any>.Type) throws -> Dictionary<String, Any> {
        let nestedContainer = try self.nestedContainer(keyedBy: JSONCodingKeys.self)
        return try nestedContainer.decode(type)
    }
}
