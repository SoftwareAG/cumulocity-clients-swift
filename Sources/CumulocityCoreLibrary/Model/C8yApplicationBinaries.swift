//
// C8yApplicationBinaries.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yApplicationBinaries: Codable {

	/// An array of attachments.
	public var attachments: [C8yAttachments]?

	enum CodingKeys: String, CodingKey {
		case attachments
	}

	public init() {
	}

	public struct C8yAttachments: Codable {
	
		/// The application context path.
		public var contextPath: String?
	
		/// The date and time when the attachment was created.
		public var created: String?
	
		/// A description for the attachment.
		public var description: String?
	
		/// A download URL for the attachment.
		public var downloadUrl: String?
	
		/// The ID of the attachment.
		public var id: String?
	
		/// The length of the attachment, in bytes.
		public var length: Int?
	
		/// The name of the attachment.
		public var name: String?
	
		enum CodingKeys: String, CodingKey {
			case contextPath
			case created
			case description
			case downloadUrl
			case id
			case length
			case name
		}
	
		public init() {
		}
	}
}
