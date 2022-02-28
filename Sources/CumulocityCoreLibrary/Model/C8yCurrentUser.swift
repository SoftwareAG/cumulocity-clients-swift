//
// C8yCurrentUser.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// The current user.
public struct C8yCurrentUser: Codable {

	/// A URL linking to this resource.
	public var `self`: String?

	/// The user's first name.
	public var firstName: String?

	/// The user's last name.
	public var lastName: String?

	/// The user's username. It can have a maximum of 1000 characters.
	public var userName: String?

	/// The user's phone number.
	public var phone: String?

	/// The user's email address.
	public var email: String?

	/// The user's password. Only Latin1 characters are allowed. If you do not specify a password when creating a new user with a POST request, it must contain the field `sendPasswordResetEmail` with a value of `true`.
	/// 
	public var password: String?

	/// A unique identifier for this user.
	public var id: String?

	/// The date and time when the user's password was last changed, in [ISO 8601 datetime format](https://www.w3.org/TR/NOTE-datetime).
	public var lastPasswordChange: String?

	/// A list of user roles.
	public var effectiveRoles: [C8yRole]?

	/// Indicates whether the user is enabled or not.
	/// Disabled users cannot log in or perform API requests.
	/// 
	public var enabled: Bool?

	/// An object with a list of the user's device permissions.
	public var devicePermissions: C8yDevicePermissions?

	enum CodingKeys: String, CodingKey {
		case `self` = "self"
		case firstName
		case lastName
		case userName
		case phone
		case email
		case password
		case id
		case lastPasswordChange
		case effectiveRoles
		case enabled
		case devicePermissions
	}

	public init() {
	}
}
