//
// TrustedCertificatesApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// API methods for managing trusted certificates used to establish device connections via MQTT.
/// 
/// More detailed information about trusted certificates and their role can be found in [Device management > Device management application > Managing device data](https://cumulocity.com/docs/device-management-application/managing-device-data/) in the Cumulocity IoT user documentation.
/// 
/// > **ⓘ Note** The Accept header must be provided in all POST/PUT requests, otherwise an empty response body will be returned.
public class TrustedCertificatesApi: AdaptableApi {

	/// Retrieve all stored certificates
	/// 
	/// Retrieve all the trusted certificates of a specific tenant (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  (ROLE_TENANT_MANAGEMENT_ADMIN *OR* ROLE_TENANT_ADMIN *OR* ROLE_TENANT_MANAGEMENT_READ) *AND* (is the current tenant) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the trusted certificates are sent in the response.
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
	public func getTrustedCertificates(tenantId: String, currentPage: Int? = nil, pageSize: Int? = nil, withTotalElements: Bool? = nil, withTotalPages: Bool? = nil) -> AnyPublisher<C8yTrustedCertificateCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/tenants/\(tenantId)/trusted-certificates")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/json")
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
		}).decode(type: C8yTrustedCertificateCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Add a new certificate
	/// 
	/// Add a new trusted certificate to a specific tenant (by a given ID) which can be further used by the devices to establish connections with the Cumulocity IoT platform.
	/// 
	/// 
	/// > Tip: Required roles
	///  (ROLE_TENANT_MANAGEMENT_ADMIN *OR* ROLE_TENANT_ADMIN) *AND* (is the current tenant) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 The certificate was added to the tenant.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Tenant not found.
	/// * HTTP 409 Duplicate ��� A certificate with the same fingerprint already exists.
	/// * HTTP 422 Unprocessable Entity ��� Invalid certificate data.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	///   - addToTrustStore:
	///     If set to `true` the certificate is added to the truststore.
	///     
	///     The truststore contains all trusted certificates. A connection to a device is only established if it connects to Cumulocity IoT with a certificate in the truststore.
	public func addTrustedCertificate(body: C8yUploadedTrustedCertificate, tenantId: String, xCumulocityProcessingMode: String? = nil, addToTrustStore: Bool? = nil) -> AnyPublisher<C8yTrustedCertificate, Error> {
		let requestBody = body
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yTrustedCertificate, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/tenants/\(tenantId)/trusted-certificates")
			.set(httpMethod: "post")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/json")
			.add(queryItem: "addToTrustStore", value: addToTrustStore)
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
	
	/// Add multiple certificates
	/// 
	/// Add multiple trusted certificates to a specific tenant (by a given ID) which can be further used by the devices to establish connections with the Cumulocity IoT platform.
	/// 
	/// 
	/// > Tip: Required roles
	///  (ROLE_TENANT_MANAGEMENT_ADMIN *OR* ROLE_TENANT_ADMIN) *AND* (is the current tenant) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 The certificates were added to the tenant.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Tenant not found.
	/// * HTTP 409 Duplicate ��� A certificate with the same fingerprint already exists.
	/// * HTTP 422 Unprocessable Entity ��� Invalid certificates data.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	///   - addToTrustStore:
	///     If set to `true` the certificate is added to the truststore.
	///     
	///     The truststore contains all trusted certificates. A connection to a device is only established if it connects to Cumulocity IoT with a certificate in the truststore.
	public func addTrustedCertificates(body: C8yUploadedTrustedCertificateCollection, tenantId: String, addToTrustStore: Bool? = nil) -> AnyPublisher<C8yTrustedCertificateCollection, Error> {
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
			.add(queryItem: "addToTrustStore", value: addToTrustStore)
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
		}).decode(type: C8yTrustedCertificateCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a stored certificate
	/// 
	/// Retrieve the data of a stored trusted certificate (by a given fingerprint) of a specific tenant (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  (ROLE_TENANT_MANAGEMENT_ADMIN *OR* ROLE_TENANT_ADMIN *OR* ROLE_TENANT_MANAGEMENT_READ) *AND* (is the current tenant *OR* is the management tenant) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the trusted certificate is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// 
	/// - Parameters:
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	///   - fingerprint:
	///     Unique identifier of a trusted certificate.
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
	/// 
	/// Update the data of a stored trusted certificate (by a given fingerprint) of a specific tenant (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  (ROLE_TENANT_MANAGEMENT_ADMIN *OR* ROLE_TENANT_ADMIN) *AND* (is the current tenant *OR* is the management tenant) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The certificate was updated on the tenant.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Certificate not found.
	/// * HTTP 422 Unprocessable Entity ��� invalid payload.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	///   - fingerprint:
	///     Unique identifier of a trusted certificate.
	public func updateTrustedCertificate(body: C8yTrustedCertificate, tenantId: String, fingerprint: String) -> AnyPublisher<C8yTrustedCertificate, Error> {
		var requestBody = body
		requestBody.proofOfPossessionValid = nil
		requestBody.notAfter = nil
		requestBody.serialNumber = nil
		requestBody.proofOfPossessionVerificationCodeUsableUntil = nil
		requestBody.subject = nil
		requestBody.algorithmName = nil
		requestBody.version = nil
		requestBody.issuer = nil
		requestBody.notBefore = nil
		requestBody.proofOfPossessionUnsignedVerificationCode = nil
		requestBody.fingerprint = nil
		requestBody.`self` = nil
		requestBody.certInPemFormat = nil
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
	/// 
	/// Remove a stored trusted certificate (by a given fingerprint) from a specific tenant (by a given ID).When a trusted certificate is deleted, the established MQTT connection to all devices that are using the corresponding certificate are closed.
	/// 
	/// 
	/// > Tip: Required roles
	///  (ROLE_TENANT_MANAGEMENT_ADMIN *OR* ROLE_TENANT_ADMIN) *AND* (is the current tenant *OR* is the management tenant) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 The trusted certificate was removed.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Certificate not found.
	/// 
	/// - Parameters:
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	///   - fingerprint:
	///     Unique identifier of a trusted certificate.
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
	/// 
	/// Provide the proof of possession for a specific uploaded certificate (by a given fingerprint) for a specific tenant (by a given ID).
	/// 
	/// 
	/// > Tip: 
	///  (ROLE_TENANT_MANAGEMENT_ADMIN *OR* ROLE_TENANT_ADMIN) *AND* is the current tenant 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The provided signed verification code check was successful.
	/// * HTTP 400 The provided signed verification code is not correct.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Trusted certificate not found.
	/// * HTTP 422 Proof of possession for the certificate was not confirmed.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	///   - fingerprint:
	///     Unique identifier of a trusted certificate.
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
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).decode(type: C8yTrustedCertificate.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Confirm an already uploaded certificate
	/// 
	/// Confirm an already uploaded certificate (by a given fingerprint) for a specific tenant (by a given ID).
	/// 
	/// 
	/// > Tip: 
	///  (ROLE_TENANT_MANAGEMENT_ADMIN *OR* ROLE_TENANT_ADMIN) *AND* is the management tenant 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The certificate is confirmed.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Trusted certificate not found.
	/// * HTTP 422 The verification was not successful. Certificate not confirmed.
	/// 
	/// - Parameters:
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	///   - fingerprint:
	///     Unique identifier of a trusted certificate.
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
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).decode(type: C8yTrustedCertificate.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Generate a verification code for the proof of possession operation for the given certificate
	/// 
	/// Generate a verification code for the proof of possession operation for the certificate (by a given fingerprint).
	/// 
	/// 
	/// > Tip: 
	///  (ROLE_TENANT_MANAGEMENT_ADMIN *OR* ROLE_TENANT_ADMIN) *AND* is the current tenant 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The verification code was generated.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Trusted certificate not found.
	/// 
	/// - Parameters:
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	///   - fingerprint:
	///     Unique identifier of a trusted certificate.
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
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).decode(type: C8yTrustedCertificate.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Verify a certificate chain
	/// 
	/// Verify a device certificate chain against a specific tenant using file upload or by HTTP headers.The tenant ID is `optional` and this api will try to resolve the tenant from the chain if not found in the request header.For file upload, the max chain length support is 10 and for a header it is 5.
	/// 
	/// If CRL (certificate revocation list) check is enabled on the tenant and the certificate chain is identified to be revoked during validation the further validation of the chain stops and returns unauthorized.
	/// 
	/// > **ⓘ Note** File upload takes precedence over HTTP headers if both are passed.
	/// 
	/// > Tip: Required roles
	///  (ROLE_TENANT_MANAGEMENT_ADMIN *OR* ROLE_TENANT_MANAGEMENT_READ) *AND* (is the current tenant *OR* is current management tenant) *OR* (is authenticated *AND* is current user service user) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The certificate chain is valid and not revoked.
	/// * HTTP 400 Unable to parse certificate chain.
	/// * HTTP 401 One or more certificates in the chain are revoked or the certificate chain is not valid. Revoked certificates are checked first, then the validity of the certificate chain.
	/// * HTTP 403 Not enough permissions/roles to perform this operation.
	/// * HTTP 404 The tenant ID does not exist.
	/// 
	/// - Parameters:
	///   - tenantId:
	///     
	///   - file:
	///     File to be uploaded.
	///   - xCumulocityClientCertChain:
	///     Used to send a certificate chain in the header. Separate the chain with `,` and also each 64 bit block with ` ` (a space character).
	public func validateChain(tenantId: String, file: Data, xCumulocityClientCertChain: String) -> AnyPublisher<C8yVerifyCertificateChain, Error> {
		let multipartBuilder = MultipartFormDataBuilder()
		do {
			try multipartBuilder.addBodyPart(named: "tenantId", codable: tenantId, mimeType: "text/plain");
		} catch {
			return Fail<C8yVerifyCertificateChain, Error>(error: error).eraseToAnyPublisher()
		}
		do {
			try multipartBuilder.addBodyPart(named: "file", codable: file, mimeType: "text/plain");
		} catch {
			return Fail<C8yVerifyCertificateChain, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/trusted-certificates/verify-cert-chain")
			.set(httpMethod: "post")
			.add(header: "X-Cumulocity-Client-Cert-Chain", value: xCumulocityClientCertChain)
			.add(header: "Content-Type", value: "multipart/form-data")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/json")
			.add(header: "Content-Type", value: multipartBuilder.contentType)
			.set(httpBody: multipartBuilder.build())
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
		}).decode(type: C8yVerifyCertificateChain.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Get revoked certificates
	/// 
	/// This endpoint downloads current CRL file containing list of revoked certificate ina binary file format with `content-type` as `application/pkix-crl`.
	/// 
	/// 
	/// > Tip: Required roles
	///  (ROLE_TENANT_MANAGEMENT_ADMIN *OR* ROLE_TENANT_ADMIN *OR* ROLE_TENANT_MANAGEMENT_READ) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The CRL file of the current tenant.
	public func downloadCrl() -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/trusted-certificates/settings/crl")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/pkix-crl")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Add revoked certificates
	/// 
	/// > **ⓘ Note** A certificate revocation list (CRL) is a list of digital certificatesthat have been revoked by the issuing certificate authority (CA) before expiration date.In Cumulocity IoT, a CRL check can be in online or offline mode or both.
	/// An endpoint to add revoked certificate serial numbers for offline CRL check via payload or file.
	/// 
	/// For payload, a JSON object required with list of CRL entries, for example:
	/// 
	/// ```json
	///   {
	///    "crls": [
	///      {
	///        "serialNumberInHex": "1000",
	///        "revocationDate": "2023-01-11T16:12:36.288Z"
	///      }
	///     ]
	///    }
	/// ```
	/// Each entry is composed of:
	/// 
	/// * serialNumberInHex: Needs to be in `Hexadecimal Value`. e.g As (1000)^16 == (4096)^10, So we have to enter 1000.If duplicate serial number exists in payload, the existing entry stays</br>
	/// * `revocationDate` - accepted Date format: `yyyy-MM-dd'T'HH:mm:ss.SSS'Z'`, for example: `2023-01-11T16:12:36.288Z`.This is an optional parameter and defaults to the current server UTC date time if not specified in the payload.If specified and the date is in future then those entries will be also defaulted to current date.
	/// 
	/// For file upload, each file can hold at maximum 5000 revocation entries.Multiple upload is allowed.In case of duplicates, the latest (last uploaded) entry is considered.
	/// 
	/// See below for a sample CSV file:
	/// 
	/// | SERIAL NO.  | REVOCATION DATE ||--|--|| 1000 | 2023-01-11T16:12:36.288Z |
	/// 
	/// Each entry is composed of :
	/// 
	/// * serialNumberInHex: Needs to be in `Hexadecimal Value`. e.g (1000)^16 == (4096)^10, So we have to enter 1000.If duplicate serial number exists in payload, the latest entry will be taken.</br>
	/// * revocationDate: Accepted Date format: `yyyy-MM-dd'T'HH:mm:ss.SSS'Z'` e.g: 2023-01-11T16:12:36.288Z.This is an optional and will be default to current server UTC date time if not specified in payload.If specified and the date is in future then those entries will be skipped.
	/// 
	/// The CRL setting for offline and online check can be enabled/disabled using <kbd><a href="#operation/putOptionResource">/tenant/options</a></kbd>.Keys are `crl.online.check.enabled` and `crl.offline.check.enabled` under the category `configuration`.
	/// 
	/// 
	/// > Tip: Required roles
	///  (ROLE_TENANT_MANAGEMENT_ADMIN *OR* ROLE_TENANT_ADMIN) *AND* is the current tenant 
	/// 
	/// **������ Important:** According to CRL policy, added serial numbers cannot be reversed.
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 CRLs updated successfully.
	/// * HTTP 400 Unsupported date time format.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not enough permissions/roles to perform this operation.
	/// 
	/// - Parameters:
	///   - body:
	///     
	public func updateCRL(body: C8yUpdateCRLEntries) -> AnyPublisher<Data, Error> {
		let requestBody = body
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<Data, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/trusted-certificates/settings/crl")
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
	
	/// Add revoked certificates
	/// 
	/// > **ⓘ Note** A certificate revocation list (CRL) is a list of digital certificatesthat have been revoked by the issuing certificate authority (CA) before expiration date.In Cumulocity IoT, a CRL check can be in online or offline mode or both.
	/// An endpoint to add revoked certificate serial numbers for offline CRL check via payload or file.
	/// 
	/// For payload, a JSON object required with list of CRL entries, for example:
	/// 
	/// ```json
	///   {
	///    "crls": [
	///      {
	///        "serialNumberInHex": "1000",
	///        "revocationDate": "2023-01-11T16:12:36.288Z"
	///      }
	///     ]
	///    }
	/// ```
	/// Each entry is composed of:
	/// 
	/// * serialNumberInHex: Needs to be in `Hexadecimal Value`. e.g As (1000)^16 == (4096)^10, So we have to enter 1000.If duplicate serial number exists in payload, the existing entry stays</br>
	/// * `revocationDate` - accepted Date format: `yyyy-MM-dd'T'HH:mm:ss.SSS'Z'`, for example: `2023-01-11T16:12:36.288Z`.This is an optional parameter and defaults to the current server UTC date time if not specified in the payload.If specified and the date is in future then those entries will be also defaulted to current date.
	/// 
	/// For file upload, each file can hold at maximum 5000 revocation entries.Multiple upload is allowed.In case of duplicates, the latest (last uploaded) entry is considered.
	/// 
	/// See below for a sample CSV file:
	/// 
	/// | SERIAL NO.  | REVOCATION DATE ||--|--|| 1000 | 2023-01-11T16:12:36.288Z |
	/// 
	/// Each entry is composed of :
	/// 
	/// * serialNumberInHex: Needs to be in `Hexadecimal Value`. e.g (1000)^16 == (4096)^10, So we have to enter 1000.If duplicate serial number exists in payload, the latest entry will be taken.</br>
	/// * revocationDate: Accepted Date format: `yyyy-MM-dd'T'HH:mm:ss.SSS'Z'` e.g: 2023-01-11T16:12:36.288Z.This is an optional and will be default to current server UTC date time if not specified in payload.If specified and the date is in future then those entries will be skipped.
	/// 
	/// The CRL setting for offline and online check can be enabled/disabled using <kbd><a href="#operation/putOptionResource">/tenant/options</a></kbd>.Keys are `crl.online.check.enabled` and `crl.offline.check.enabled` under the category `configuration`.
	/// 
	/// 
	/// > Tip: Required roles
	///  (ROLE_TENANT_MANAGEMENT_ADMIN *OR* ROLE_TENANT_ADMIN) *AND* is the current tenant 
	/// 
	/// **������ Important:** According to CRL policy, added serial numbers cannot be reversed.
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 CRLs updated successfully.
	/// * HTTP 400 Unsupported date time format.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not enough permissions/roles to perform this operation.
	/// 
	/// - Parameters:
	///   - file:
	///     File to be uploaded.
	public func updateCRL(file: Data) -> AnyPublisher<Data, Error> {
		let multipartBuilder = MultipartFormDataBuilder()
		do {
			try multipartBuilder.addBodyPart(named: "file", codable: file, mimeType: "text/plain");
		} catch {
			return Fail<Data, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/trusted-certificates/settings/crl")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "multipart/form-data")
			.add(header: "Accept", value: "application/json")
			.add(header: "Content-Type", value: multipartBuilder.contentType)
			.set(httpBody: multipartBuilder.build())
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
	
	/// Obtain device access token
	/// 
	/// Only those devices which are registered to use cert auth can authenticate via mTLS protocol and retrieve JWT token. Device access token API works only on port 8443 via mutual TLS (mTLS) connection.Immediate issuer of client certificate must present in Platform's truststore, if not then whole certificate chain needs to send in header and root or any intermediate certificate must be present in the Platform's truststore.We must have the following:
	/// 
	/// * private_key
	/// * client certificate
	/// * whole certificate chain (Optional - This API requires the client to send a custom header `X-SSL-CERT-CHAIN` only if the immediate issuer of the client's certificate is not uploaded as a trusted certificate on the platform. If the immediate issuer is already uploaded and trusted, the header can be omitted)
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 Successfully retrieved device access token from device certificate.
	/// * HTTP 400 Unable to parse certificate chain.
	/// * HTTP 401 One or more certificates in the chain are revoked or the certificate chain is not valid. Revoked certificates are checked first, then the validity of the certificate chain.
	/// * HTTP 404 Device access token feature is disabled.
	/// * HTTP 422 The verification was not successful.
	/// 
	/// - Parameters:
	///   - xSslCertChain:
	///     Used to send a certificate chain in the header. Separate the chain with ` ` (a space character) and also each 64 bit block with ` ` (a space character).
	public func obtainAccessToken(xSslCertChain: String? = nil) -> AnyPublisher<C8yAccessToken, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol/deviceAccessToken")
			.set(httpMethod: "post")
			.add(header: "X-Ssl-Cert-Chain", value: xSslCertChain)
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
		}).decode(type: C8yAccessToken.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
