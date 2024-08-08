//
// LoginOptionsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// API methods to retrieve the login options configured in the tenant.
/// 
/// More detailed information about the parameters and their meaning can be found in [Platform administration > Standard tenant administration > Changing settings](https://cumulocity.com/docs/standard-tenant/changing-settings/) in the Cumulocity IoT user documentation.
/// 
/// > **ⓘ Note** If OAuth external is the only login option shown in the response, the user will be automatically redirected to the SSO login screen.
public class LoginOptionsApi: AdaptableApi {

	/// Retrieve all login options
	/// 
	/// Retrieve all login options available in the tenant.
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the login options are sent in the response.
	/// * HTTP 400 Bad request ��� invalid parameters.
	/// 
	/// - Parameters:
	///   - management:
	///     If this is set to `true`, the management tenant login options will be returned.
	///     
	///     **ⓘ Note** The `tenantId` parameter must not be present in the request when using the `management` parameter, otherwise it will cause an error.
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	public func getLoginOptions(management: Bool? = nil, tenantId: String? = nil) -> AnyPublisher<C8yLoginOptionCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/loginOptions")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.loginoptioncollection+json")
			.add(queryItem: "management", value: management)
			.add(queryItem: "tenantId", value: tenantId)
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
		}).decode(type: C8yLoginOptionCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create a login option
	/// 
	/// Create an authentication configuration on your tenant.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_TENANT_ADMIN *OR* ROLE_TENANT_MANAGEMENT_ADMIN 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 A login option was created.
	/// * HTTP 400 Duplicated ��� The login option already exists.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 422 Unprocessable Entity ��� invalid payload.
	/// 
	/// - Parameters:
	///   - body:
	///     
	public func createLoginOption(body: C8yAuthConfig) -> AnyPublisher<C8yAuthConfig, Error> {
		var requestBody = body
		requestBody.`self` = nil
		requestBody.id = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yAuthConfig, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/loginOptions")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.authconfig+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.authconfig+json")
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
		}).decode(type: C8yAuthConfig.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific login option
	/// 
	/// Retrieve a specific login option in the tenant by the given type or ID.
	/// 
	/// 
	/// > Tip: Required roles
	///  ((ROLE_TENANT_ADMIN *OR* ROLE_TENANT_MANAGEMENT_ADMIN *OR* ROLE_USER_MANAGEMENT_OWN_ADMIN *OR* ROLE_USER_MANAGEMENT_CREATE) *AND* tenant access to login option is not restricted by management tenant) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the login option is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// * HTTP 404 Login option not found.
	/// 
	/// - Parameters:
	///   - typeOrId:
	///     The type or ID of the login option. The type's value is case insensitive and can be `OAUTH2`, `OAUTH2_INTERNAL` or `BASIC`.
	public func getLoginOption(typeOrId: String) -> AnyPublisher<C8yAuthConfig, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/loginOptions/\(typeOrId)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.authConfig+json")
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
		}).decode(type: C8yAuthConfig.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update a specific login option
	/// 
	/// Update a specific login option in the tenant by a given type or ID.
	/// 
	/// 
	/// > Tip: Required roles
	///  ((ROLE_TENANT_ADMIN *OR* ROLE_TENANT_MANAGEMENT_ADMIN) *AND* tenant access to login option is not restricted by management tenant) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 A login option was updated.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// * HTTP 404 Login option not found.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - typeOrId:
	///     The type or ID of the login option. The type's value is case insensitive and can be `OAUTH2`, `OAUTH2_INTERNAL` or `BASIC`.
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func updateLoginOption(body: C8yAuthConfig, typeOrId: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<C8yAuthConfig, Error> {
		var requestBody = body
		requestBody.`self` = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yAuthConfig, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/loginOptions/\(typeOrId)")
			.set(httpMethod: "put")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.authconfig+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.authconfig+json")
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
		}).decode(type: C8yAuthConfig.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Delete a specific login option
	/// 
	/// Delete a specific login option in the tenant by a given type or ID.
	/// 
	/// 
	/// > Tip: Required roles
	///  ((ROLE_TENANT_ADMIN *OR* ROLE_TENANT_MANAGEMENT_ADMIN) *AND* tenant access to login option is not restricted by management tenant) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 A login option was removed.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// * HTTP 404 Login option not found.
	/// 
	/// - Parameters:
	///   - typeOrId:
	///     The type or ID of the login option. The type's value is case insensitive and can be `OAUTH2`, `OAUTH2_INTERNAL` or `BASIC`.
	public func deleteLoginOption(typeOrId: String) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/loginOptions/\(typeOrId)")
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
	
	/// Update a tenant's access to the login option
	/// 
	/// Update the tenant's access to the authentication configuration.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_TENANT_MANAGEMENT_ADMIN *AND* is the management tenant 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The login option was updated.
	/// * HTTP 403 Not authorized to perform this operation.
	/// * HTTP 404 Tenant not found.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - typeOrId:
	///     The type or ID of the login option. The type's value is case insensitive and can be `OAUTH2`, `OAUTH2_INTERNAL` or `BASIC`.
	///   - targetTenant:
	///     Unique identifier of a Cumulocity IoT tenant.
	public func updateLoginOptionAccess(body: C8yAuthConfigAccess, typeOrId: String, targetTenant: String) -> AnyPublisher<C8yAuthConfig, Error> {
		let requestBody = body
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yAuthConfig, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/loginOptions/\(typeOrId)/restrict")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "application/json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.authconfig+json")
			.add(queryItem: "targetTenant", value: targetTenant)
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
		}).decode(type: C8yAuthConfig.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
