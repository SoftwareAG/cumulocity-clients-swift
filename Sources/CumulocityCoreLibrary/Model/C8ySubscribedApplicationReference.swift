//
// C8ySubscribedApplicationReference.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8ySubscribedApplicationReference: Codable {

	/// The application to be subscribed to.
	public var application: C8yApplication?

	enum CodingKeys: String, CodingKey {
		case application
	}

	public init(application: C8yApplication) {
		self.application = application
	}

	/// The application to be subscribed to.
	public struct C8yApplication: Codable {
	
		/// A URL linking to this resource.
		public var `self`: String?
	
		enum CodingKeys: String, CodingKey {
			case `self` = "self"
		}
	
		public init(pSelf: String) {
			self.`self` = pSelf
		}
	}
}
