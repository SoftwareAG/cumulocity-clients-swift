//
// CurrentUserApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// The current user is the user that is currently authenticated with Cumulocity IoT for the API calls.
/// 
/// > **ⓘ Note** The Accept header should be provided in all PUT requests, otherwise an empty response body will be returned.
public class CurrentUserApi: AdaptableApi {

	/// Retrieve the current user
	/// 
	/// Retrieve the user reference of the current user.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_OWN_READ *OR* ROLE_SYSTEM 
	/// 
	/// Users with ROLE_SYSTEM are not allowed to query with Accept header `application/vnd.com.nsn.cumulocity.user+json`
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the current user is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	public func getCurrentUser() -> AnyPublisher<C8yCurrentUser, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/currentUser")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.currentuser+json, application/vnd.com.nsn.cumulocity.user+json")
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
		}).decode(type: C8yCurrentUser.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update the current user
	/// 
	/// Update the current user.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_OWN_ADMIN 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The current user was updated.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 422 Unprocessable Entity ��� invalid payload.
	/// 
	/// - Parameters:
	///   - body:
	///     
	public func updateCurrentUser(body: C8yCurrentUser) -> AnyPublisher<C8yCurrentUser, Error> {
		var requestBody = body
		requestBody.`self` = nil
		requestBody.effectiveRoles = nil
		requestBody.shouldResetPassword = nil
		requestBody.id = nil
		requestBody.lastPasswordChange = nil
		requestBody.twoFactorAuthenticationEnabled = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yCurrentUser, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/currentUser")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.currentuser+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.currentuser+json")
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
		}).decode(type: C8yCurrentUser.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update the current user's password
	/// 
	/// Update the current user's  password.
	/// 
	/// > **������ Important:** If the tenant uses OAI-Secure authentication, the current user will not be logged out. Instead, a new cookie will be set with a new token, and the previous token will expire within a minute.
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_OWN_ADMIN 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The current user password was updated.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 422 Unprocessable Entity ��� invalid payload.
	/// 
	/// - Parameters:
	///   - body:
	///     
	public func updateCurrentUserPassword(body: C8yPasswordChange) -> AnyPublisher<Data, Error> {
		let requestBody = body
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<Data, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/currentUser/password")
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
	
	/// Generate secret to set up TFA
	/// 
	/// Generate a secret code to create a QR code to set up the two-factor authentication functionality using a TFA app/service.
	/// 
	/// For more information about the feature, see [Platform administration > Authentication > Two-factor authentication](https://cumulocity.com/docs/authentication/tfa/) in the Cumulocity IoT user documentation.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_OWN_READ *OR* ROLE_SYSTEM 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the secret is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	public func generateTfaSecret() -> AnyPublisher<C8yCurrentUserTotpSecret, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/currentUser/totpSecret")
			.set(httpMethod: "post")
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
		}).decode(type: C8yCurrentUserTotpSecret.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Returns the activation state of the two-factor authentication feature.
	/// 
	/// Returns the activation state of the two-factor authentication feature for the current user.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_OWN_READ *OR* ROLE_SYSTEM 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 Returns the activation state.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 User not found.
	public func getTfaState() -> AnyPublisher<C8yCurrentUserTotpSecretActivity, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/currentUser/totpSecret/activity")
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
		}).decode(type: C8yCurrentUserTotpSecretActivity.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Activates or deactivates the two-factor authentication feature
	/// 
	/// Activates or deactivates the two-factor authentication feature for the current user.
	/// 
	/// For more information about the feature, see [Platform administration > Authentication > Two-factor authentication](https://cumulocity.com/docs/authentication/tfa/) in the Cumulocity IoT user documentation.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_OWN_READ *OR* ROLE_SYSTEM 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 The two-factor authentication was activated or deactivated.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Cannot deactivate TOTP setup.
	/// * HTTP 409 TFA TOTP secret does not exist. First generate secret.
	/// 
	/// - Parameters:
	///   - body:
	///     
	public func setTfaState(body: C8yCurrentUserTotpSecretActivity) -> AnyPublisher<Data, Error> {
		let requestBody = body
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<Data, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/currentUser/totpSecret/activity")
			.set(httpMethod: "post")
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
	
	/// Verify TFA code
	/// 
	/// Verifies the authentication code that the current user received from a TFA app/service and uploaded to the platform to gain access or enable the two-factor authentication feature.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_OWN_READ *OR* ROLE_SYSTEM 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 The sent code was correct and the access can be granted.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Invalid verification code.
	/// * HTTP 404 Cannot validate TFA TOTP code - user's TFA TOTP secret does not exist.
	/// * HTTP 422 Unprocessable Entity ��� invalid payload.
	/// 
	/// - Parameters:
	///   - body:
	///     
	public func verifyTfaCode(body: C8yCurrentUserTotpCode) -> AnyPublisher<Data, Error> {
		let requestBody = body
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<Data, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/currentUser/totpSecret/verify")
			.set(httpMethod: "post")
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
}
