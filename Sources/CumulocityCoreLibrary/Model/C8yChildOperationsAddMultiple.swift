//
// C8yChildOperationsAddMultiple.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yChildOperationsAddMultiple: Codable {

	/// An array containing the IDs of the managed objects (children).
	public var references: [C8yReferences]?

	enum CodingKeys: String, CodingKey {
		case references
	}

	public init(references: [C8yReferences]) {
		self.references = references
	}

	public struct C8yReferences: Codable {
	
		public var managedObject: C8yManagedObject?
	
		enum CodingKeys: String, CodingKey {
			case managedObject
		}
	
		public init() {
		}
	
		public struct C8yManagedObject: Codable {
		
			/// Unique identifier of the object.
			public var id: String?
		
			enum CodingKeys: String, CodingKey {
				case id
			}
		
			public init(id: String) {
				self.id = id
			}
		}
	}
}
