//
// C8yCellInfo.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// Provides detailed information about the closest mobile cell towers. When the functionality is activated, the location of the device is determined based on this fragment, in order to track the device whereabouts when GPS tracking is not available.
public struct C8yCellInfo: Codable {

	/// The radio type of this cell tower.
	public var radioType: String?

	/// Detailed information about the neighboring cell towers.
	public var cellTowers: [C8yCellTower]?

	enum CodingKeys: String, CodingKey {
		case radioType
		case cellTowers
	}

	public init(cellTowers: [C8yCellTower]) {
		self.cellTowers = cellTowers
	}
}
