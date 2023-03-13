//
// C8yAgent.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// The term "agent" refers to the piece of software that connects a device with Cumulocity IoT.
public struct C8yAgent: Codable {

	/// The name of the agent.
	public var name: String?

	/// The version of the agent.
	public var version: String?

	/// The URL of the agent, for example, its code repository.
	public var url: String?

	enum CodingKeys: String, CodingKey {
		case name
		case version
		case url
	}

	public init(name: String, version: String) {
		self.name = name
		self.version = version
	}
}
