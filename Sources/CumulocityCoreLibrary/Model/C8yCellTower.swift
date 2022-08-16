//
// C8yCellTower.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// Detailed information about a neighbouring cell tower.
public struct C8yCellTower: Codable {

	/// The radio type of this cell tower. Can also be put directly in root JSON element if all cellTowers have same radioType.
	public var radioType: String?

	/// The Mobile Country Code (MCC).
	public var mobileCountryCode: Double?

	/// The Mobile Noetwork Code (MNC) for GSM, WCDMA and LTE. The SystemID (sid) for CDMA.
	public var mobileNetworkCode: Double?

	/// The Location Area Code (LAC) for GSM, WCDMA and LTE. The Network ID for CDMA.
	public var locationAreaCode: Double?

	/// The Cell ID (CID) for GSM, WCDMA and LTE. The Basestation ID for CDMA.
	public var cellId: Double?

	/// The timing advance value for this cell tower when available.
	public var timingAdvance: Double?

	/// The signal strength for this cell tower in dBm.
	public var signalStrength: Double?

	/// The primary scrambling code for WCDMA and physical CellId for LTE.
	public var primaryScramblingCode: Double?

	/// Specify with 0/1 if the cell is serving or not. If not specified, the first cell is assumed to be serving.
	public var serving: Double?

	enum CodingKeys: String, CodingKey {
		case radioType
		case mobileCountryCode
		case mobileNetworkCode
		case locationAreaCode
		case cellId
		case timingAdvance
		case signalStrength
		case primaryScramblingCode
		case serving
	}

	public init(mobileCountryCode: Double, mobileNetworkCode: Double, locationAreaCode: Double, cellId: Double) {
		self.mobileCountryCode = mobileCountryCode
		self.mobileNetworkCode = mobileNetworkCode
		self.locationAreaCode = locationAreaCode
		self.cellId = cellId
	}
}
