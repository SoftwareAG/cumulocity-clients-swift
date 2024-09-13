//
// TenantApplicationsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// References to the tenant subscribed applications.
/// 
/// > **ⓘ Note** The Accept header should be provided in all POST requests, otherwise an empty response body will be returned.
public class TenantApplicationsApi: AdaptableApi {

	/// Retrieve subscribed applications
	/// 
	/// Retrieve the tenant subscribed applications by a given tenant ID.
	/// 
	/// 
	/// > Tip: Required roles
	///  (ROLE_TENANT_MANAGEMENT_READ *OR* ROLE_TENANT_ADMIN) *AND* (the current tenant is its parent *OR* is the management tenant) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the tenant applications are sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// * HTTP 404 Tenant not found.
	/// 
	/// - Parameters:
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	///   - currentPage:
	///     The current page of the paginated results.
	///   - pageSize:
	///     Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	///   - withTotalElements:
	///     When set to `true`, the returned result will contain in the statistics object the total number of elements. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	///   - withTotalPages:
	///     When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getSubscribedApplications(tenantId: String, currentPage: Int? = nil, pageSize: Int? = nil, withTotalElements: Bool? = nil, withTotalPages: Bool? = nil) -> AnyPublisher<C8yApplicationReferenceCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/tenants/\(tenantId)/applications")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.applicationreferencecollection+json")
			.add(queryItem: "currentPage", value: currentPage)
			.add(queryItem: "pageSize", value: pageSize)
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
		}).decode(type: C8yApplicationReferenceCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Subscribe to an application
	/// 
	/// Subscribe a tenant (by a given ID) to an application.
	/// 
	/// 
	/// > Tip: Required roles
	///  1. the current tenant is application owner and has the role ROLE_APPLICATION_MANAGEMENT_ADMIN *OR*
	///  2. for applications that are not microservices, the current tenant is the management tenant or the parent of the application owner tenant, and the user has one of the follwoing roles: ROLE_TENANT_MANAGEMENT_ADMIN, ROLE_TENANT_MANAGEMENT_UPDATE *OR*
	///  3. for microservices, the current tenant is the management tenant or the parent of the application owner tenant, and the user has the role ROLE_TENANT_MANAGEMENT_ADMIN OR ROLE_TENANT_MANAGEMENT_UPDATE and one of following conditions is met:
	///  * the microservice has no manifest
	///  * the microservice version is supported
	///  * the current tenant is subscribed to 'feature-privileged-microservice-hosting' 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 A tenant was subscribed to an application.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Application not found.
	/// * HTTP 409 The application is already assigned to the tenant.
	/// * HTTP 422 Unprocessable Entity – invalid payload.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	public func subscribeApplication(body: C8ySubscribedApplicationReference, tenantId: String) -> AnyPublisher<C8yApplicationReference, Error> {
		let requestBody = body
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yApplicationReference, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/tenants/\(tenantId)/applications")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.applicationreference+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.applicationreference+json")
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
		}).decode(type: C8yApplicationReference.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Unsubscribe from an application
	/// 
	/// Unsubscribe a tenant (by a given tenant ID) from an application (by a given application ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  (ROLE_APPLICATION_MANAGEMENT_ADMIN *AND* is the application owner *AND* is the current tenant) *OR*
	///  ((ROLE_TENANT_MANAGEMENT_ADMIN *OR* ROLE_TENANT_MANAGEMENT_UPDATE) *AND* (the current tenant is its parent *OR* is the management tenant)) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 A tenant was unsubscribed from an application.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Tenant not found.
	/// 
	/// - Parameters:
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	///   - applicationId:
	///     Unique identifier of the application.
	public func unsubscribeApplication(tenantId: String, applicationId: String) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/tenants/\(tenantId)/applications/\(applicationId)")
			.set(httpMethod: "delete")
			.add(header: "Accept", value: "application/json")
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
		}).eraseToAnyPublisher()
	}
}
