//
// AuditsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// An audit log stores events that are security-relevant and should be stored for auditing. For example, an audit log should be generated when a user logs into a gateway.
/// 
/// An audit log extends an event through:
/// 
/// * A username of the user that carried out the activity.
/// * An application that was used to carry out the activity.
/// * The actual activity.
/// * A severity.
/// 
/// > **&#9432; Info:** The Accept header should be provided in all POST requests, otherwise an empty response body will be returned.
/// 
public class AuditsApi: AdaptableApi {

	/// Retrieve all audit records
	/// Retrieve all audit records registered on your tenant, or a specific subset based on queries.
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and all audit records are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- application 
	///		  Name of the application from which the audit was carried out.
	/// 	- currentPage 
	///		  The current page of the paginated results.
	/// 	- dateFrom 
	///		  Start date or date and time of the audit record.
	/// 	- dateTo 
	///		  End date or date and time of the audit record.
	/// 	- pageSize 
	///		  Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	/// 	- source 
	///		  The platform component ID to which the audit is associated.
	/// 	- type 
	///		  The type of audit record to search for.
	/// 	- user 
	///		  The username to search for.
	/// 	- withTotalElements 
	///		  When set to `true`, the returned result will contain in the statistics object the total number of elements. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	/// 	- withTotalPages 
	///		  When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getAuditRecords(application: String? = nil, currentPage: Int? = nil, dateFrom: String? = nil, dateTo: String? = nil, pageSize: Int? = nil, source: String? = nil, type: String? = nil, user: String? = nil, withTotalElements: Bool? = nil, withTotalPages: Bool? = nil) throws -> AnyPublisher<C8yAuditRecordCollection, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = application { queryItems.append(URLQueryItem(name: "application", value: String(parameter))) }
		if let parameter = currentPage { queryItems.append(URLQueryItem(name: "currentPage", value: String(parameter))) }
		if let parameter = dateFrom { queryItems.append(URLQueryItem(name: "dateFrom", value: String(parameter))) }
		if let parameter = dateTo { queryItems.append(URLQueryItem(name: "dateTo", value: String(parameter))) }
		if let parameter = pageSize { queryItems.append(URLQueryItem(name: "pageSize", value: String(parameter))) }
		if let parameter = source { queryItems.append(URLQueryItem(name: "source", value: String(parameter))) }
		if let parameter = type { queryItems.append(URLQueryItem(name: "type", value: String(parameter))) }
		if let parameter = user { queryItems.append(URLQueryItem(name: "user", value: String(parameter))) }
		if let parameter = withTotalElements { queryItems.append(URLQueryItem(name: "withTotalElements", value: String(parameter))) }
		if let parameter = withTotalPages { queryItems.append(URLQueryItem(name: "withTotalPages", value: String(parameter))) }
		let builder = URLRequestBuilder()
			.set(resourcePath: "/audit/auditRecords")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.auditrecordcollection+json")
			.set(queryItems: queryItems)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error401)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yAuditRecordCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create an audit record
	/// Create an audit record.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_AUDIT_ADMIN <b>OR</b> ROLE_SYSTEM <b>OR</b> AUDIT_ADMIN permission on the resource
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  An audit record was created.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- body 
	public func createAuditRecord(body: C8yAuditRecord) throws -> AnyPublisher<C8yAuditRecord, Swift.Error> {
		var requestBody = body
		requestBody.severity = nil
		requestBody.application = nil
		requestBody.creationTime = nil
		requestBody.c8yMetadata = nil
		requestBody.changes = nil
		requestBody.`self` = nil
		requestBody.id = nil
		requestBody.source?.`self` = nil
		let builder = URLRequestBuilder()
			.set(resourcePath: "/audit/auditRecords")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.auditrecord+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.auditrecord+json")
			.set(httpBody: try JSONEncoder().encode(requestBody))
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error401)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yAuditRecord.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific audit record
	/// Retrieve a specific audit record by a given ID.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_AUDIT_READ <b>OR</b> AUDIT_READ permission on the source
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the audit record is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the audit record.
	public func getAuditRecord(id: String) throws -> AnyPublisher<C8yAuditRecord, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/audit/auditRecords/\(id)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.auditrecord+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error401)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yAuditRecord.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
