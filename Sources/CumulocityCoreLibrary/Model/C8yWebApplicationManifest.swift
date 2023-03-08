//
// C8yWebApplicationManifest.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// The manifest of the web application.
public struct C8yWebApplicationManifest: Codable {

	/// A legacy flag that identified a certain type of web application that would control the behavior of plugin tab in the application details view.It is no longer used.
	@available(*, deprecated)
	public var pWebpaas: Bool?

	/// The content security policy of the application.
	public var contentSecurityPolicy: String?

	/// A flag that decides if the application is shown in the app switcher on the UI.
	public var noAppSwitcher: Bool?

	/// A flag that decides if the application tabs are displayed horizontally or not.
	public var tabsHorizontal: Bool?

	enum CodingKeys: String, CodingKey {
		case pWebpaas
		case contentSecurityPolicy
		case noAppSwitcher
		case tabsHorizontal
	}

	public init() {
	}
}
