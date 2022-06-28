//
// C8yRealtimeNotification.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yRealtimeNotification: Codable {

	/// Configuration parameters for the current connect message.
	public var advice: C8yAdvice?

	/// The channel name as a URI.
	public var channel: C8yChannel?

	/// Unique client ID generated by the server during handshake. Required for all other operations.
	public var clientId: String?

	/// Selected connection type.
	public var connectionType: String?

	/// List of notifications from the channel.
	public var data: C8yData?

	/// Operation failure reason (only present if the operation was not successful).
	public var error: String?

	/// Authentication object passed to handshake (only over WebSockets).
	public var ext: C8yExt?

	/// ID of the message passed in a request. Required to match the response message.
	public var id: String?

	/// Minimum server-side Bayeux protocol version required by the client (in a request) or minimum client-side Bayeux protocol version required by the server (in a response).
	public var minimumVersion: String?

	/// Name of the channel to subscribe to. Subscription channels are available for [Alarms](#tag/Alarm-notification-API), [Device control](#tag/Device-control-notification-API), [Events](#tag/Event-notification-API), [Inventory](#tag/Inventory-notification-API) and [Measurements](#tag/Measurement-notification-API).
	public var subscription: String?

	/// Indicates if the operation was successful.
	public var successful: Bool?

	/// Connection types supported by both client and server, that is, intersection between client and server options.
	public var supportedConnectionTypes: [String]?

	/// [Bayeux protocol](https://docs.cometd.org/current/reference/#_concepts_bayeux_protocol) version used by the client (in a request) or server (in a response).
	/// 
	public var version: String?

	enum CodingKeys: String, CodingKey {
		case advice
		case channel
		case clientId
		case connectionType
		case data
		case error
		case ext
		case id
		case minimumVersion
		case subscription
		case successful
		case supportedConnectionTypes
		case version
	}

	public init(channel: C8yChannel) {
		self.channel = channel
	}

	/// The channel name as a URI.
	public enum C8yChannel: String, Codable {
		case metahandshake = "/meta/handshake"
		case metasubscribe = "/meta/subscribe"
		case metaunsubscribe = "/meta/unsubscribe"
		case metaconnect = "/meta/connect"
		case metadisconnect = "/meta/disconnect"
	}

	/// Configuration parameters for the current connect message.
	public struct C8yAdvice: Codable {
	
		/// Period (milliseconds) after which the server will close the session, if it doesn't received the next connect message from the client. Overrides server default settings for current request-response conversation.
		public var interval: Int?
	
		/// Interval (milliseconds) between the sending of the connect message and the response from the server. Overrides server default settings for the current request-response conversation.
		public var timeout: Int?
	
		enum CodingKeys: String, CodingKey {
			case interval
			case timeout
		}
	
		public init() {
		}
	}


	/// List of notifications from the channel.
	public struct C8yData: Codable {
	
		public init() {
		}
	}

	/// Authentication object passed to handshake (only over WebSockets).
	public struct C8yExt: Codable {
	
		public var comcumulocityauthn: C8yComcumulocityauthn?
	
		/// The system of units to use.
		public var systemOfUnits: C8ySystemOfUnits?
	
		enum CodingKeys: String, CodingKey {
			case comcumulocityauthn = "com.cumulocity.authn"
			case systemOfUnits
		}
	
		public init() {
		}
	
		/// The system of units to use.
		public enum C8ySystemOfUnits: String, Codable {
			case imperial = "imperial"
			case metric = "metric"
		}
	
		public struct C8yComcumulocityauthn: Codable {
		
			/// Base64 encoded credentials.
			public var token: String?
		
			/// Optional two factor authentication token.
			public var tfa: String?
		
			/// Required for OAuth authentication.
			public var xsrfToken: String?
		
			enum CodingKeys: String, CodingKey {
				case token
				case tfa
				case xsrfToken
			}
		
			public init() {
			}
		}
	
	}
}