//
// AuditApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// The audit API resource returns URIs and URI templates to collections of audit records, so that they can be retrieved by criteria such as “all records from a particular user”, or “all records from a particular application”.
/// 
/// ### Audited information:
/// 
/// * Alarm modifications
/// * Operation modifications
/// * Two-factor authentication login attempts
/// * Smart rule modifications
/// * Complex Event Processing (CEP) module modifications
/// * User and group permissions modifications
/// * SSO and OAuth Internal logout and login attempts
/// 
public class AuditApi: AdaptableApi {

	public override init() {
		super.init()
	}

	public override init(requestBuilder: URLRequestBuilder) {
		super.init(requestBuilder: requestBuilder)
	}

	/// Retrieve URIs to collections of audits
	/// Retrieve URIs and URI templates to collections of audit records.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_AUDIT_READ
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the URIs are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	public func getAuditApiResource() throws -> AnyPublisher<C8yAuditApiResource, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/audit")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.auditapi+json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yAuditApiResource.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
