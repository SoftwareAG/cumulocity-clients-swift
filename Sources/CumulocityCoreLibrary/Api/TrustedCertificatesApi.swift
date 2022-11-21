//
// TrustedCertificatesApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// API methods for managing trusted certificates used to establish device connections via MQTT.
/// 
/// More detailed information about trusted certificates and their role can be found in [Device management > Managing device data](https://cumulocity.com/guides/users-guide/device-management/#managing-device-data) in the *User guide*.
/// 
/// > **&#9432; Info:** The Accept header must be provided in all POST/PUT requests, otherwise an empty response body will be returned.
/// 
public class TrustedCertificatesApi: AdaptableApi {

	/// Retrieve all stored certificates
	/// Retrieve all the trusted certificates of a specific tenant (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// (ROLE_TENANT_MANAGEMENT_ADMIN <b>OR</b> ROLE_TENANT_ADMIN) <b>AND</b> (is the current tenant)
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the trusted certificates are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not authorized to perform this operation.
	/// 	- 404
	///		  Tenant not found.
	/// - Parameters:
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	/// 	- currentPage 
	///		  The current page of the paginated results.
	/// 	- pageSize 
	///		  Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	/// 	- withTotalElements 
	///		  When set to `true`, the returned result will contain in the statistics object the total number of elements. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	/// 	- withTotalPages 
	///		  When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getTrustedCertificates(tenantId: String, currentPage: Int? = nil, pageSize: Int? = nil, withTotalElements: Bool? = nil, withTotalPages: Bool? = nil) -> AnyPublisher<C8yTrustedCertificateCollection, Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = currentPage { queryItems.append(URLQueryItem(name: "currentPage", value: String(parameter))) }
		if let parameter = pageSize { queryItems.append(URLQueryItem(name: "pageSize", value: String(parameter))) }
		if let parameter = withTotalElements { queryItems.append(URLQueryItem(name: "withTotalElements", value: String(parameter))) }
		if let parameter = withTotalPages { queryItems.append(URLQueryItem(name: "withTotalPages", value: String(parameter))) }
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/tenants/\(tenantId)/trusted-certificates")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/json")
			.set(queryItems: queryItems)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).decode(type: C8yTrustedCertificateCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Add a new certificate
	/// Add a new trusted certificate to a specific tenant (by a given ID) which can be further used by the devices to establish connections with the Cumulocity IoT platform.
	/// 
	/// <section><h5>Required roles</h5>
	/// (ROLE_TENANT_MANAGEMENT_ADMIN <b>OR</b> ROLE_TENANT_ADMIN) <b>AND</b> (is the current tenant)
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  The certificate was added to the tenant.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Tenant not found.
	/// 	- 409
	///		  Duplicate – A certificate with the same fingerprint already exists.
	/// 	- 422
	///		  Unprocessable Entity – Invalid certificate data.
	/// - Parameters:
	/// 	- body 
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	public func addTrustedCertificate(body: C8yTrustedCertificate, tenantId: String) -> AnyPublisher<C8yTrustedCertificate, Error> {
		var requestBody = body
		requestBody.notAfter = nil
		requestBody.serialNumber = nil
		requestBody.subject = nil
		requestBody.fingerprint = nil
		requestBody.`self` = nil
		requestBody.algorithmName = nil
		requestBody.version = nil
		requestBody.issuer = nil
		requestBody.notBefore = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yTrustedCertificate, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/tenants/\(tenantId)/trusted-certificates")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/json")
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
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).decode(type: C8yTrustedCertificate.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Add multiple certificates
	/// Add multiple trusted certificates to a specific tenant (by a given ID) which can be further used by the devices to establish connections with the Cumulocity IoT platform.
	/// 
	/// <section><h5>Required roles</h5>
	/// (ROLE_TENANT_MANAGEMENT_ADMIN <b>OR</b> ROLE_TENANT_ADMIN) <b>AND</b> (is the current tenant)
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  The certificates were added to the tenant.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Tenant not found.
	/// 	- 409
	///		  Duplicate – A certificate with the same fingerprint already exists.
	/// 	- 422
	///		  Unprocessable Entity – Invalid certificates data.
	/// - Parameters:
	/// 	- body 
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	public func addTrustedCertificates(body: C8yTrustedCertificateCollection, tenantId: String) -> AnyPublisher<C8yTrustedCertificateCollection, Error> {
		var requestBody = body
		requestBody.next = nil
		requestBody.prev = nil
		requestBody.`self` = nil
		requestBody.statistics = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yTrustedCertificateCollection, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/tenants/\(tenantId)/trusted-certificates/bulk")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/json")
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
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).decode(type: C8yTrustedCertificateCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a stored certificate
	/// Retrieve the data of a stored trusted certificate (by a given fingerprint) of a specific tenant (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// (ROLE_TENANT_MANAGEMENT_ADMIN <b>OR</b> ROLE_TENANT_ADMIN) <b>AND</b> (is the current tenant <b>OR</b> is the management tenant)
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the trusted certificate is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	/// 	- fingerprint 
	///		  Unique identifier of a trusted certificate.
	public func getTrustedCertificate(tenantId: String, fingerprint: String) -> AnyPublisher<C8yTrustedCertificate, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/tenants/\(tenantId)/trusted-certificates/\(fingerprint)")
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
		}).decode(type: C8yTrustedCertificate.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update a stored certificate
	/// Update the data of a stored trusted certificate (by a given fingerprint) of a specific tenant (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// (ROLE_TENANT_MANAGEMENT_ADMIN <b>OR</b> ROLE_TENANT_ADMIN) <b>AND</b> (is the current tenant <b>OR</b> is the management tenant)
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The certificate was updated on the tenant.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Certificate not found.
	/// 	- 422
	///		  Unprocessable Entity – invalid payload.
	/// - Parameters:
	/// 	- body 
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	/// 	- fingerprint 
	///		  Unique identifier of a trusted certificate.
	public func updateTrustedCertificate(body: C8yTrustedCertificate, tenantId: String, fingerprint: String) -> AnyPublisher<C8yTrustedCertificate, Error> {
		var requestBody = body
		requestBody.notAfter = nil
		requestBody.serialNumber = nil
		requestBody.subject = nil
		requestBody.fingerprint = nil
		requestBody.`self` = nil
		requestBody.certInPemFormat = nil
		requestBody.algorithmName = nil
		requestBody.version = nil
		requestBody.issuer = nil
		requestBody.notBefore = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yTrustedCertificate, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/tenants/\(tenantId)/trusted-certificates/\(fingerprint)")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "application/json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/json")
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
		}).decode(type: C8yTrustedCertificate.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove a stored certificate
	/// Remove a stored trusted certificate (by a given fingerprint) from a specific tenant (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// (ROLE_TENANT_MANAGEMENT_ADMIN <b>OR</b> ROLE_TENANT_ADMIN) <b>AND</b> (is the current tenant <b>OR</b> is the management tenant)
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  The trusted certificate was removed.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Certificate not found.
	/// - Parameters:
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	/// 	- fingerprint 
	///		  Unique identifier of a trusted certificate.
	public func removeTrustedCertificate(tenantId: String, fingerprint: String) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/tenants/\(tenantId)/trusted-certificates/\(fingerprint)")
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
	
	/// Provide the proof of possession for an already uploaded certificate
	/// Provide the proof of possession for a specific uploaded certificate (by a given fingerprint) for a specific tenant (by a given ID).
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// (ROLE_TENANT_MANAGEMENT_ADMIN <b>OR</b> ROLE_TENANT_ADMIN) <b>AND</b> is the current tenant
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The provided signed verification code check was successful.
	/// 	- 400
	///		  The provided signed verification code is not correct.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Trusted certificate not found.
	/// 	- 422
	///		  Proof of possession for the certificate was not confirmed.
	/// - Parameters:
	/// 	- body 
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	/// 	- fingerprint 
	///		  Unique identifier of a trusted certificate.
	public func proveCertificatePossession(body: C8yUploadedTrustedCertSignedVerificationCode, tenantId: String, fingerprint: String) -> AnyPublisher<C8yTrustedCertificate, Error> {
		let requestBody = body
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yTrustedCertificate, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/tenants/\(tenantId)/trusted-certificates-pop/\(fingerprint)/pop")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/json")
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
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).decode(type: C8yTrustedCertificate.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Confirm an already uploaded certificate
	/// Confirm an already uploaded certificate (by a given fingerprint) for a specific tenant (by a given ID).
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// (ROLE_TENANT_MANAGEMENT_ADMIN <b>OR</b> ROLE_TENANT_ADMIN) <b>AND</b> is the management tenant
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The certificate is confirmed.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Trusted certificate not found.
	/// 	- 422
	///		  The verification was not successful. Certificate not confirmed.
	/// - Parameters:
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	/// 	- fingerprint 
	///		  Unique identifier of a trusted certificate.
	public func confirmCertificate(tenantId: String, fingerprint: String) -> AnyPublisher<C8yTrustedCertificate, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/tenants/\(tenantId)/trusted-certificates-pop/\(fingerprint)/confirmed")
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
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).decode(type: C8yTrustedCertificate.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Generate a verification code for the proof of possession operation for the given certificate
	/// Generate a verification code for the proof of possession operation for the certificate (by a given fingerprint).
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// (ROLE_TENANT_MANAGEMENT_ADMIN <b>OR</b> ROLE_TENANT_ADMIN) <b>AND</b> is the current tenant
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The verification code was generated.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Trusted certificate not found.
	/// - Parameters:
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	/// 	- fingerprint 
	///		  Unique identifier of a trusted certificate.
	public func generateVerificationCode(tenantId: String, fingerprint: String) -> AnyPublisher<C8yTrustedCertificate, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/tenants/\(tenantId)/trusted-certificates-pop/\(fingerprint)/verification-code")
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
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).decode(type: C8yTrustedCertificate.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
