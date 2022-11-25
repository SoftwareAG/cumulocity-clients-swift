//
// C8yRequestRepresentation.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yRequestRepresentation: Codable {

	/// Body of the request.
	public var body: String?

	/// Headers of the request.
	public var headers: C8yHeaders?

	/// HTTP request method.
	public var method: C8yMethod?

	/// Requested operation.
	public var operation: C8yOperation?

	/// Parameters of the request.
	public var requestParams: C8yRequestParams?

	/// Target of the request described as a URL.
	public var url: String?

	enum CodingKeys: String, CodingKey {
		case body
		case headers
		case method
		case operation
		case requestParams
		case url
	}

	public init() {
	}

	/// HTTP request method.
	public enum C8yMethod: String, Codable {
		case get = "GET"
		case post = "POST"
	}

	/// Requested operation.
	public enum C8yOperation: String, Codable {
		case execute = "EXECUTE"
		case redirect = "REDIRECT"
	}

	/// Headers of the request.
	public struct C8yHeaders: Codable {
	
		/// It is possible to add an arbitrary number of headers as a list of key-value string pairs, for example, `"header": "value"`.
		/// 
		public var requestHeaders: [String: String] = [:]
		
		public subscript(key: String) -> String? {
		        get {
		            return requestHeaders[key]
		        }
		        set(newValue) {
		            requestHeaders[key] = newValue
		        }
		    }
	
		enum CodingKeys: String, CodingKey {
			case requestHeaders
		}
	
		public init() {
		}
	}



	/// Parameters of the request.
	public struct C8yRequestParams: Codable {
	
		/// It is possible to add an arbitrary number of parameters as a list of key-value string pairs, for example, `"parameter": "value"`.
		/// 
		public var requestParameters: [String: String] = [:]
		
		public subscript(key: String) -> String? {
		        get {
		            return requestParameters[key]
		        }
		        set(newValue) {
		            requestParameters[key] = newValue
		        }
		    }
	
		enum CodingKeys: String, CodingKey {
			case requestParameters
		}
	
		public init() {
		}
	}
}
