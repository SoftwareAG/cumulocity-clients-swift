//
// FeatureTogglesApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

public class FeatureTogglesApi: AdaptableApi {

	/// Retrieve list of feature toggles with values for current tenant.
	/// 
	/// Retrieve a list of all defined feature toggles with values calculated for a tenant of authenticated user.
	/// 
	/// 
	/// > Tip: Required roles
	///  none, any authenticated user can call this endpoint 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the feature toggles are sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	public func listCurrentTenantFeatures() -> AnyPublisher<[C8yFeatureToggle], Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/features")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/json")
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
		}).decode(type: [C8yFeatureToggle].self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific feature toggle with value for current tenant.
	/// 
	/// Retrieve a specific feature toggles defined under given key, with value calculated for a tenant of authenticated user.
	/// 
	/// 
	/// > Tip: Required roles
	///  none, any authenticated user can call this endpoint 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the feature toggle is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	public func getCurrentTenantFeature() -> AnyPublisher<C8yFeatureToggle, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/features/\(featurekey)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/json")
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
		}).decode(type: C8yFeatureToggle.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve list of feature toggles values overrides of all tenants.
	/// 
	/// Retrieve a list of all existing feature toggle value overrides for all tenants.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_TENANT_MANAGEMENT_ADMIN *AND* current tenant is management 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the feature toggles are sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// * HTTP 404 Managed object not found.
	public func listTenantFeatureToggleValues() -> AnyPublisher<[C8yTenantFeatureToggleValue], Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/features/\(featurekey)/by-tenant")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/json")
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
		}).decode(type: [C8yTenantFeatureToggleValue].self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Sets the value of feature toggle override for the current tenant.
	/// 
	/// Sets the value of feature toggle override for a tenant of authenticated user.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_TENANT_MANAGEMENT_ADMIN *AND* (current tenant is management *OR* the feature toggle phase is PUBLIC_PREVIEW or GENERALLY_AVAILABLE) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the feature toggle value override was set.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// * HTTP 404 Managed object not found.
	/// 
	/// - Parameters:
	///   - body:
	///     
	public func setCurrentTenantFeatureToggleValue(body: C8yFeatureToggleValue) -> AnyPublisher<Data, Error> {
		let requestBody = body
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<Data, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/features/\(featurekey)/by-tenant")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "application/json")
			.add(header: "Accept", value: "application/json")
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
		}).eraseToAnyPublisher()
	}
	
	/// Removes the feature toggle override for the current tenant.
	/// 
	/// Removes the feature toggle override for a tenant of authenticated user.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_TENANT_MANAGEMENT_ADMIN *AND* (current tenant is management *OR* the feature toggle phase is PUBLIC_PREVIEW or GENERALLY_AVAILABLE) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the feature toggle value override was removed.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// * HTTP 404 Managed object not found.
	public func unsetCurrentTenantFeatureToggleValue() -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/features/\(featurekey)/by-tenant")
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
	
	/// Sets the value of feature toggle override for a given tenant.
	/// 
	/// Sets the value of feature toggle override for a given tenant.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_TENANT_MANAGEMENT_ADMIN *AND* current tenant is management. 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the feature toggle value override was set.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// * HTTP 404 Managed object not found.
	/// 
	/// - Parameters:
	///   - body:
	///     
	public func setGivenTenantFeatureToggleValue(body: C8yFeatureToggleValue) -> AnyPublisher<Data, Error> {
		let requestBody = body
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<Data, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/features/\(featurekey)/by-tenant/\(tenantid)")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "application/json")
			.add(header: "Accept", value: "application/json")
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
		}).eraseToAnyPublisher()
	}
	
	/// Removes the feature toggle override for a given tenant.
	/// 
	/// Removes the feature toggle override for a given tenant.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_TENANT_MANAGEMENT_ADMIN *AND* current tenant is management. 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the feature toggle value override was removed.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// * HTTP 404 Managed object not found.
	public func unsetGivenTenantFeatureToggleValue() -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/features/\(featurekey)/by-tenant/\(tenantid)")
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
