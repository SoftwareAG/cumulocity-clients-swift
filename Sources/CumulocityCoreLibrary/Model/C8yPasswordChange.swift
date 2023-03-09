//
// C8yPasswordChange.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yPasswordChange: Codable {

	/// The current password of the user performing the request.
	public var currentUserPassword: String?

	/// The new password to be set for the user performing the request.
	public var newPassword: String?

	enum CodingKeys: String, CodingKey {
		case currentUserPassword
		case newPassword
	}

	public init(currentUserPassword: String, newPassword: String) {
		self.currentUserPassword = currentUserPassword
		self.newPassword = newPassword
	}
}
