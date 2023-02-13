//
// ApplicationVersionsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// API methods to retrieve, create, update and delete application versions.
public class ApplicationVersionsApi: AdaptableApi {

	/// Retrieve a specific version of an application
	/// Retrieve the selected version of an application in your tenant. To select the version, use only the version or only the tag query parameter.
	/// <section><h5>Required roles</h5> ROLE_APPLICATION_MANAGEMENT_READ </section>
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the application version is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Application not found.
	/// 	- 422
	///		  both parameters (version and tag) are present.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the application.
	/// 	- version 
	///		  The version field of the application version.
	/// 	- tag 
	///		  The tag of the application version.
	public func getApplicationVersion(id: String, version: String? = nil, tag: String? = nil) -> AnyPublisher<C8yApplicationVersion, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applications\\(id)/versions?version=1.0")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.applicationVersion+json")
			.add(queryItem: "version", value: version)
			.add(queryItem: "tag", value: tag)
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
		}).decode(type: C8yApplicationVersion.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve all versions of an application
	/// Retrieve all versions of an application in your tenant.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_APPLICATION_MANAGEMENT_READ
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the list of application versions is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Application version not found.
	/// 	- 422
	///		  This application doesn't support versioning.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the application.
	public func getApplicationVersions(id: String) -> AnyPublisher<C8yApplicationVersionCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applications\\(id)/versions")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.applicationVersionCollection+json")
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
		}).decode(type: C8yApplicationVersionCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create an application version
	/// Create an application version in your tenant.
	/// 
	/// Uploaded version and tags can only contain upper and lower case letters, integers and `.`,` + `,` -`. Other characters are prohibited.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_APPLICATION_MANAGEMENT_ADMIN
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  An application version was created.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Application version not found.
	/// 	- 409
	///		  Duplicate version/tag or versions limit exceeded.
	/// 	- 422
	///		  tag or version contains unacceptable characters.
	/// - Parameters:
	/// 	- applicationBinary 
	///		  The ZIP file to be uploaded.
	/// 	- applicationVersion 
	///		  The JSON file with version information.
	/// 	- id 
	///		  Unique identifier of the application.
	public func createApplicationVersion(applicationBinary: Data, applicationVersion: String, id: String) -> AnyPublisher<C8yApplicationVersion, Error> {
		let multipartBuilder = MultipartFormDataBuilder()
		multipartBuilder.addBodyPart(named: "applicationBinary", data: applicationBinary, mimeType: "application/zip");
		do {
			try multipartBuilder.addBodyPart(named: "applicationVersion", codable: applicationVersion, mimeType: "text/plain");
		} catch {
			return Fail<C8yApplicationVersion, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applications\\(id)/versions")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "multipart/form-data")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.applicationVersion+json")
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
		}).decode(type: C8yApplicationVersion.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Delete a specific version of an application
	/// Delete a specific version of an application in your tenant, by a given tag or version.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_APPLICATION_MANAGEMENT_READ
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  A version was removed.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Application version not found.
	/// 	- 409
	///		  Version with tag latest cannot be removed.
	/// 	- 422
	///		  both parameters (version and tag) are present.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the application.
	/// 	- version 
	///		  The version field of the application version.
	/// 	- tag 
	///		  The tag of the application version.
	public func deleteApplicationVersion(id: String, version: String? = nil, tag: String? = nil) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applications\\(id)/versions")
			.set(httpMethod: "delete")
			.add(header: "Accept", value: "application/json")
			.add(queryItem: "version", value: version)
			.add(queryItem: "tag", value: tag)
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
	
	/// Replace an application version's tags
	/// Replaces the tags of a given application version in your tenant.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_APPLICATION_MANAGEMENT_ADMIN
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  An application version was updated.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Application version not found.
	/// 	- 409
	///		  Duplicate version/tag or versions limit exceeded.
	/// 	- 422
	///		  tag contains unacceptable characters.
	/// - Parameters:
	/// 	- body 
	/// 	- id 
	///		  Unique identifier of the application.
	/// 	- version 
	///		  Version of the application.
	public func updateApplicationVersion(body: C8yApplicationVersionTag, id: String, version: String) -> AnyPublisher<C8yApplicationVersion, Error> {
		let requestBody = body
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yApplicationVersion, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applications\\(id)/versions\\(version)")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "application/json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.applicationVersion+json")
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
		}).decode(type: C8yApplicationVersion.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
