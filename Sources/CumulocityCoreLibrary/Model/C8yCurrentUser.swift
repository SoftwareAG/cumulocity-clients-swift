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

	/// A list of user roles.
	public var effectiveRoles: [C8yRole]?

	/// The user's email address.
	public var email: String?

	/// The user's first name.
	public var firstName: String?

	/// A unique identifier for this user.
	public var id: String?

	/// The user's last name.
	public var lastName: String?

	/// The date and time when the user's password was last changed, in [ISO 8601 datetime format](https://www.w3.org/TR/NOTE-datetime).
	public var lastPasswordChange: String?

	/// The user's password. Only Latin1 characters are allowed.
	public var password: String?

	/// The user's phone number.
	public var phone: String?

	/// A URL linking to this resource.
	public var `self`: String?

	/// Indicates if the user should reset the password on the next login.
	public var shouldResetPassword: Bool?

	/// The user's username. It can have a maximum of 1000 characters.
	public var userName: String?

	/// An object with a list of the user's device permissions.
	@available(*, deprecated)
	public var devicePermissions: C8yDevicePermissions?

	enum CodingKeys: String, CodingKey {
		case effectiveRoles
		case email
		case firstName
		case id
		case lastName
		case lastPasswordChange
		case password
		case phone
		case `self` = "self"
		case shouldResetPassword
		case userName
		case devicePermissions
	}

	public init() {
	}
}
