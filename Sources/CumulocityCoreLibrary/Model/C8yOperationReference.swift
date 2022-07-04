//
// C8yOperationReference.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yOperationReference: Codable {

	/// The referenced operation.
	public var operation: C8yOperation?

	/// A URL linking to this resource.
	public var `self`: String?

	enum CodingKeys: String, CodingKey {
		case operation
		case `self` = "self"
	}

	public init() {
	}

	/// The referenced operation.
	public struct C8yOperation: Codable {
	
		/// Unique identifier of this operation.
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
