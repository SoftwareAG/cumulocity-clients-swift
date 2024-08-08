//
// ApplicationBinariesApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// An API method to upload an application binary. It is a deployable microservice or web application.
public class ApplicationBinariesApi: AdaptableApi {

	/// Retrieve all application attachments
	/// 
	/// Retrieve all application attachments.This method is not supported by microservice applications.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_APPLICATION_MANAGEMENT_ADMIN 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the application attachments are sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Application not found.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the application.
	public func getApplicationAttachments(id: String) -> AnyPublisher<C8yApplicationBinaries, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applications/\(id)/binaries")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.applicationbinaries+json, application/vnd.com.nsn.cumulocity.error+json")
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
		}).decode(type: C8yApplicationBinaries.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Upload an application attachment
	/// 
	/// Upload an application attachment (by a given application ID).
	/// 
	/// For the applications of type ���microservice��� and ���web application��� to be available for Cumulocity IoT platform users, an attachment ZIP file must be uploaded.
	/// 
	/// For a microservice application, the ZIP file must consist of:
	/// 
	/// * cumulocity.json - file describing the deployment
	/// * image.tar - executable Docker image
	/// 
	/// For a web application, the ZIP file must include an index.html file in the root directory.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_APPLICATION_MANAGEMENT_ADMIN *AND* tenant is the owner of the application 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 The application attachments have been uploaded.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// 
	/// - Parameters:
	///   - file:
	///     The ZIP file to be uploaded.
	///   - id:
	///     Unique identifier of the application.
	public func uploadApplicationAttachment(file: Data, id: String) -> AnyPublisher<C8yApplication, Error> {
		let multipartBuilder = MultipartFormDataBuilder()
		multipartBuilder.addBodyPart(named: "file", data: file, mimeType: "application/zip");
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applications/\(id)/binaries")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "multipart/form-data")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.application+json")
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
		}).decode(type: C8yApplication.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific application attachment
	/// 
	/// Retrieve a specific application attachment (by a given application ID and a given binary ID).This method is not supported by microservice applications.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_APPLICATION_MANAGEMENT_ADMIN 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the application attachment is sent as a ZIP file in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the application.
	///   - binaryId:
	///     Unique identifier of the binary.
	public func getApplicationAttachment(id: String, binaryId: String) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applications/\(id)/binaries/\(binaryId)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/zip")
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
	
	/// Delete a specific application attachment
	/// 
	/// Delete  a specific application attachment (by a given application ID and a given binary ID).This method is not supported by microservice applications.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_APPLICATION_MANAGEMENT_ADMIN *AND* tenant is the owner of the application 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 An application binary was removed.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the application.
	///   - binaryId:
	///     Unique identifier of the binary.
	public func deleteApplicationAttachment(id: String, binaryId: String) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applications/\(id)/binaries/\(binaryId)")
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
