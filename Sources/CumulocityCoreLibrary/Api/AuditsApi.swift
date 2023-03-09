//
// AuditsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
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
/// > **ⓘ Note** The Accept header should be provided in all POST requests, otherwise an empty response body will be returned.
public class AuditsApi: AdaptableApi {

	/// Retrieve all audit records
	/// 
	/// Retrieve all audit records registered on your tenant, or a specific subset based on queries.
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and all audit records are sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// 
	/// - Parameters:
	///   - application:
	///     Name of the application from which the audit was carried out.
	///   - currentPage:
	///     The current page of the paginated results.
	///   - dateFrom:
	///     Start date or date and time of the audit record.
	///   - dateTo:
	///     End date or date and time of the audit record.
	///   - pageSize:
	///     Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	///   - source:
	///     The platform component ID to which the audit is associated.
	///   - type:
	///     The type of audit record to search for.
	///   - user:
	///     The username to search for.
	///   - withTotalElements:
	///     When set to `true`, the returned result will contain in the statistics object the total number of elements. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	///   - withTotalPages:
	///     When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getAuditRecords(application: String? = nil, currentPage: Int? = nil, dateFrom: String? = nil, dateTo: String? = nil, pageSize: Int? = nil, source: String? = nil, type: String? = nil, user: String? = nil, withTotalElements: Bool? = nil, withTotalPages: Bool? = nil) -> AnyPublisher<C8yAuditRecordCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/audit/auditRecords")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.auditrecordcollection+json")
			.add(queryItem: "application", value: application)
			.add(queryItem: "currentPage", value: currentPage)
			.add(queryItem: "dateFrom", value: dateFrom)
			.add(queryItem: "dateTo", value: dateTo)
			.add(queryItem: "pageSize", value: pageSize)
			.add(queryItem: "source", value: source)
			.add(queryItem: "type", value: type)
			.add(queryItem: "user", value: user)
			.add(queryItem: "withTotalElements", value: withTotalElements)
			.add(queryItem: "withTotalPages", value: withTotalPages)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).decode(type: C8yAuditRecordCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create an audit record
	/// 
	/// Create an audit record.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_AUDIT_ADMIN *OR* ROLE_SYSTEM *OR* AUDIT_ADMIN permission on the resource 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 An audit record was created.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// 
	/// - Parameters:
	///   - body:
	///     
	public func createAuditRecord(body: C8yAuditRecord) -> AnyPublisher<C8yAuditRecord, Error> {
		var requestBody = body
		requestBody.severity = nil
		requestBody.application = nil
		requestBody.creationTime = nil
		requestBody.c8yMetadata = nil
		requestBody.changes = nil
		requestBody.`self` = nil
		requestBody.id = nil
		requestBody.source?.`self` = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yAuditRecord, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/audit/auditRecords")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.auditrecord+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.auditrecord+json")
			.set(httpBody: encodedRequestBody)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).decode(type: C8yAuditRecord.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific audit record
	/// 
	/// Retrieve a specific audit record by a given ID.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_AUDIT_READ *OR* AUDIT_READ permission on the source 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the audit record is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the audit record.
	public func getAuditRecord(id: String) -> AnyPublisher<C8yAuditRecord, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/audit/auditRecords/\(id)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.auditrecord+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).decode(type: C8yAuditRecord.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
