//
// CurrentUserApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// The current user is the user that is currently authenticated with Cumulocity IoT for the API calls.
/// 
/// > **&#9432; Info:** The Accept header should be provided in all PUT requests, otherwise an empty response body will be returned.
/// 
public class CurrentUserApi: AdaptableApi {

	/// Retrieve the current user
	/// Retrieve the user reference of the current user.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_USER_MANAGEMENT_OWN_READ <b>OR</b> ROLE_SYSTEM
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the current user is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	public func getCurrentUser() -> AnyPublisher<C8yCurrentUser, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/currentUser")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.currentuser+json")
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
	/// Update the current user.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_USER_MANAGEMENT_ADMIN
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The current user was updated.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 422
	///		  Unprocessable Entity – invalid payload.
	/// - Parameters:
	/// 	- body 
	/// 	- xCumulocityProcessingMode 
	///		  Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func updateCurrentUser(body: C8yCurrentUser, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<C8yCurrentUser, Error> {
		var requestBody = body
		requestBody.`self` = nil
		requestBody.effectiveRoles = nil
		requestBody.shouldResetPassword = nil
		requestBody.id = nil
		requestBody.lastPasswordChange = nil
		requestBody.twoFactorAuthenticationEnabled = nil
		requestBody.devicePermissions = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yCurrentUser, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/currentUser")
			.set(httpMethod: "put")
			.add(header: "X-Cumulocity-Processing-Mode", value: String(describing: xCumulocityProcessingMode))
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
	/// Update the current user's  password.
	/// 
	/// > **⚠️ Important:** If the tenant uses OAI-Secure authentication, the current user will not be logged out. Instead, a new cookie will be set with a new token, and the previous token will expire within a minute.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_USER_MANAGEMENT_OWN_ADMIN
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The current user password was updated.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 422
	///		  Unprocessable Entity – invalid payload.
	/// - Parameters:
	/// 	- body 
	/// 	- xCumulocityProcessingMode 
	///		  Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func updateCurrentUserPassword(body: C8yPasswordChange, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<Data, Error> {
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
			.add(header: "X-Cumulocity-Processing-Mode", value: String(describing: xCumulocityProcessingMode))
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
	/// Generate a secret code to create a QR code to set up the two-factor authentication functionality using a TFA app/service.
	/// 
	/// For more information about the feature, see [User Guide > Administration > Two-factor authentication](https://cumulocity.com/guides/users-guide/administration/#tfa) in the *Cumulocity IoT documentation*.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_USER_MANAGEMENT_OWN_READ <b>OR</b> ROLE_SYSTEM
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the secret is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- xCumulocityProcessingMode 
	///		  Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func generateTfaSecret(xCumulocityProcessingMode: String? = nil) -> AnyPublisher<C8yCurrentUserTotpSecret, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/currentUser/totpSecret")
			.set(httpMethod: "post")
			.add(header: "X-Cumulocity-Processing-Mode", value: String(describing: xCumulocityProcessingMode))
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
	/// Returns the activation state of the two-factor authentication feature for the current user.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_USER_MANAGEMENT_OWN_READ <b>OR</b> ROLE_SYSTEM
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  Returns the activation state.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  User not found.
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
	/// Activates or deactivates the two-factor authentication feature for the current user.
	/// 
	/// For more information about the feature, see [User Guide > Administration > Two-factor authentication](https://cumulocity.com/guides/users-guide/administration/#tfa) in the *Cumulocity IoT documentation*.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_USER_MANAGEMENT_OWN_READ <b>OR</b> ROLE_SYSTEM
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  The two-factor authentication was activated or deactivated.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Cannot deactivate TOTP setup.
	/// 	- 404
	///		  User not found.
	/// - Parameters:
	/// 	- body 
	/// 	- xCumulocityProcessingMode 
	///		  Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func setTfaState(body: C8yCurrentUserTotpSecretActivity, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<Data, Error> {
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
			.add(header: "X-Cumulocity-Processing-Mode", value: String(describing: xCumulocityProcessingMode))
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
	/// Verifies the authentication code that the current user received from a TFA app/service and uploaded to the platform to gain access or enable the two-factor authentication feature.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_USER_MANAGEMENT_OWN_READ <b>OR</b> ROLE_SYSTEM
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  The sent code was correct and the access can be granted.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Invalid verification code.
	/// 	- 404
	///		  Cannot validate TFA TOTP code - user's TFA TOTP secret does not exist.
	/// 	- 422
	///		  Unprocessable Entity – invalid payload.
	/// - Parameters:
	/// 	- body 
	/// 	- xCumulocityProcessingMode 
	///		  Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func verifyTfaCode(body: C8yCurrentUserTotpCode, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<Data, Error> {
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
			.add(header: "X-Cumulocity-Processing-Mode", value: String(describing: xCumulocityProcessingMode))
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
