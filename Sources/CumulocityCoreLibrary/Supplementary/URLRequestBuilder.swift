//
// URLRequestBuilder.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public class URLRequestBuilder {

    var components: URLComponents
    private var httpMethod: String?
    private var requestHeaders: [String: String] = [:]
    private var httpBody: Data?

    public init() {
		self.components = URLComponents()
	}

    public convenience init(with: URLRequestBuilder) {
        self.init()
		self.components = with.components
		self.httpMethod = with.httpMethod
		self.requestHeaders = with.requestHeaders
		self.httpBody = with.httpBody
	}

    public func set(scheme: String) -> URLRequestBuilder {
        self.components.scheme = scheme
        return self
    }

    public func set(host: String) -> URLRequestBuilder {
        self.components.host = host
        return self
    }

    public func set(resourcePath: String) -> URLRequestBuilder {
        self.components.path = resourcePath
        return self
    }

    public func set(httpMethod: String) -> URLRequestBuilder {
		self.httpMethod = httpMethod
		return self
	}

	public func add(header: String, value: String) -> URLRequestBuilder {
		guard !value.isEmpty else {
			return self
		}
		self.requestHeaders[header] = value
		return self
	}

	public func set(authorization userName: String, password: String) -> URLRequestBuilder {
		let credentials = "\(userName):\(password)"
		if let encodedCredentials = credentials.data(using: .utf8) {
			self.requestHeaders["Authorization"] = "Basic " + encodedCredentials.base64EncodedString()
		}
		return self
	}

	public func set(queryItems: [URLQueryItem]) -> URLRequestBuilder {
		self.components.queryItems = queryItems
		return self
	}

	public func set(httpBody: Data) -> URLRequestBuilder {
        self.httpBody = httpBody
        return self
    }

	public func build() -> URLRequest {
		var urlRequest = URLRequest(url: self.components.url!)
		urlRequest.httpMethod = self.httpMethod
		for (name, value) in self.requestHeaders {
			urlRequest.addValue(value, forHTTPHeaderField: name)
		}
		if let httpBody = self.httpBody {
			urlRequest.httpBody = httpBody
		}
		return urlRequest
	}
}

extension URLRequestBuilder {

	public func merge(with builder: URLRequestBuilder) -> URLRequestBuilder {
		if let scheme = builder.components.scheme {
			self.components.scheme = scheme
		}
		if let host = builder.components.host {
			self.components.host = host
		}
		if !builder.components.path.isEmpty {
			self.components.path = builder.components.path
		}
		for (k, v) in builder.requestHeaders {
			_ = self.add(header: k, value: v)
		}
        if let queryItems = builder.components.queryItems {
			if (self.components.queryItems == nil) {
				self.components.queryItems = queryItems
			} else {
				for q in queryItems {
					self.components.queryItems?.append(q)
				}
			}
		}
		if (self.httpBody == nil) {
			if let httpBody = builder.httpBody {
				self.set(httpBody: httpBody)
			}
		}
		if (self.httpMethod == nil) {
			if let httpMethod = builder.httpMethod {
				self.set(httpMethod: httpMethod)
			}
		}
		return self
	}
}
