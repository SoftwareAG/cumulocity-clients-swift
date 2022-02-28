//
// ApplicationBinariesApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// An API method to upload an application binary. It is a deployable microservice or web application.
public class ApplicationBinariesApi: AdaptableApi {

	public override init() {
		super.init()
	}

	public override init(requestBuilder: URLRequestBuilder) {
		super.init(requestBuilder: requestBuilder)
	}

	/// Retrieve all application attachments
	/// Retrieve all application attachments.
	/// This method is not supported by microservice applications.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_APPLICATION_MANAGEMENT_ADMIN
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the application attachments are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Application not found.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the application.
	public func getBinaryApplicationContentResource(id: String) throws -> AnyPublisher<C8yApplicationBinaries, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applications/\(id)/binaries")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.applicationbinaries+json, application/vnd.com.nsn.cumulocity.error+json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yApplicationBinaries.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Upload an application attachment
	/// Upload an application attachment (by a given application ID).
	/// 
	/// For the applications of type “microservice” and “web application” to be available for Cumulocity IoT platform users, an attachment ZIP file must be uploaded.
	/// 
	/// For a microservice application, the ZIP file must consist of:
	/// 
	/// * cumulocity.json - file describing the deployment
	/// * image.tar - executable Docker image
	/// 
	/// For a web application, the ZIP file must include an index.html file in the root directory.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_APPLICATION_MANAGEMENT_ADMIN <b>AND</b> tenant is the owner of the application
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  The application attachments have been uploaded.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- file 
	///		  The ZIP file to be uploaded.
	/// 	- id 
	///		  Unique identifier of the application.
	public func postBinaryApplicationContentResource(file: Data, id: String) throws -> AnyPublisher<C8yApplication, Swift.Error> {
		let multipartBuilder = MultipartFormDataBuilder()
		try multipartBuilder.addBodyPart(named: "file", data: file, mimeType: "application/zip");
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applications/\(id)/binaries")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "multipart/form-data")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.application+json")
			.add(header: "Content-Type", value: multipartBuilder.contentType)
			.set(httpBody: multipartBuilder.build())
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yApplication.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific application attachment
	/// Retrieve a specific application attachment (by a given application ID and a given binary ID).
	/// This method is not supported by microservice applications.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_APPLICATION_MANAGEMENT_ADMIN
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the application attachment is sent as a ZIP file in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the application.
	/// 	- binaryId 
	///		  Unique identifier of the binary.
	public func getBinaryApplicationContentResourceById(id: String, binaryId: String) throws -> AnyPublisher<Data, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applications/\(id)/binaries/\(binaryId)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Delete a specific application attachment
	/// Delete  a specific application attachment (by a given application ID and a given binary ID).
	/// This method is not supported by microservice applications.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_APPLICATION_MANAGEMENT_ADMIN <b>AND</b> tenant is the owner of the application
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  An application binary was removed.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not authorized to perform this operation.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the application.
	/// 	- binaryId 
	///		  Unique identifier of the binary.
	public func deleteBinaryApplicationContentResourceById(id: String, binaryId: String) throws -> AnyPublisher<Data, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applications/\(id)/binaries/\(binaryId)")
			.set(httpMethod: "delete")
			.add(header: "Accept", value: "application/json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).eraseToAnyPublisher()
	}
}
