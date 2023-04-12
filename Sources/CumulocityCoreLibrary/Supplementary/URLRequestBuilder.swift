//
// URLRequestBuilder.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public class URLRequestBuilder {

	public enum ParameterSerializationType {
		case comma_separated
		case exploded
	}

    var components: URLComponents
    private var httpMethod: String?
    private var requestHeaders: [String: String] = [:]
    private var httpBody: Data?
    private var queryItems: [URLQueryItem] = []

    public init() {
		self.components = URLComponents()
	}

    public convenience init(with: URLRequestBuilder) {
    	self.init()
		self.components = with.components
		self.httpMethod = with.httpMethod
		self.requestHeaders = with.requestHeaders
		self.httpBody = with.httpBody
		self.queryItems = with.queryItems
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

	public func add<Subject>(header: String, value: Subject?) -> URLRequestBuilder {
        if let v = value {
            let valueAsString = String(describing: v)
            guard !valueAsString.isEmpty else {
                return self
            }
            self.requestHeaders[header] = valueAsString
        }
        return self
    }

	public func set(authorization userName: String, password: String) -> URLRequestBuilder {
		let credentials = "\(userName):\(password)"
		if let encodedCredentials = credentials.data(using: .utf8) {
			self.requestHeaders["Authorization"] = "Basic " + encodedCredentials.base64EncodedString()
		}
		return self
	}

	/// Appends a ``URLQueryItem`` based on the passed ``key``/``value`` pair if ``value`` is not nil.
    ///
    /// The parameter will be serialized as `?key=value`.
	public func add<Subject>(queryItem key: String, value: Subject?) -> URLRequestBuilder {
        if let v = value {
            let valueAsString = String(describing: v)
            guard !valueAsString.isEmpty else {
                return self
            }
            self.queryItems.append(URLQueryItem(name: key, value: valueAsString))
        }
        return self
    }

    /// Appends a ``URLQueryItem`` based on the passed ``key``/``value`` pair if ``value`` is not nil.
    ///
    /// The parameter `explode` defines the serialisation method:
    /// - If `true`, parameter will be serialized as `?key=1&key=2&key=3`.
    /// - If `false`, parameter will be serialized as `?key=1,2,3`.
    public func add<Subject>(queryItem key: String, value: [Subject]?, explode: ParameterSerializationType = .exploded) -> URLRequestBuilder {
        if let v = value {
            if explode == .exploded {
                v.forEach { e in
                    _ = self.add(queryItem: key, value: e)
                }
            } else {
                _ = self.add(queryItem: key, value: v.map{String(describing: $0)}.joined(separator: ","))
            }
        }
        return self
    }

	public func set(httpBody: Data?) -> URLRequestBuilder {
        self.httpBody = httpBody
        return self
    }

	public func build() -> URLRequest {
		self.components.queryItems = queryItems
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
        self.queryItems.append(contentsOf: builder.queryItems)
		if (self.httpBody == nil) {
			if let httpBody = builder.httpBody {
				_ = self.set(httpBody: httpBody)
			}
		}
		if (self.httpMethod == nil) {
			if let httpMethod = builder.httpMethod {
				_ = self.set(httpMethod: httpMethod)
			}
		}
		return self
	}
}
