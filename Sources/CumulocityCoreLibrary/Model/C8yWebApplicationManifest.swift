//
// C8yWebApplicationManifest.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// The manifest of the web application.
public struct C8yWebApplicationManifest: Codable {

	/// A legacy flag that identified a certain type of web application that would control the behavior of plugin tab in the application details view.
	/// It is no longer used.
	/// 
	@available(*, deprecated)
	public var pWebpaas: Bool?

	/// A flag that decides if the application tabs are displayed horizontally or not.
	public var tabsHorizontal: Bool?

	/// The content security policy of the application.
	/// > **&#9432; Info:** This property is specific to the web application type.
	/// 
	public var contentSecurityPolicy: String?

	/// A flag that decides if the application is shown in the app switcher on the UI.
	public var noAppSwitcher: Bool?

	enum CodingKeys: String, CodingKey {
		case pWebpaas
		case tabsHorizontal
		case contentSecurityPolicy
		case noAppSwitcher
	}

	public init() {
	}
}
