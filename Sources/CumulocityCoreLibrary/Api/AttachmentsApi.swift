//
// AttachmentsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// It is possible to store, retrieve and delete binaries for events. Each event can have one binary attached.
public class AttachmentsApi: AdaptableApi {

	/// Retrieve the attached file of a specific event
	/// 
	/// Retrieve the attached file (binary) of a specific event by a given ID.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_EVENT_READ *OR* EVENT_READ permission on the source 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the file is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Attachment not found.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the event.
	public func getEventAttachment(id: String) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/event/events/\(id)/binaries")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/octet-stream")
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
	
	/// Replace the attached file of a specific event
	/// 
	/// Upload and replace the attached file (binary) of a specific event by a given ID.
	/// The size of the attachment is configurable, and the default size is 50 MiB. The default chunk size is 5MiB.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_EVENT_ADMIN *OR* owner of the source *OR* EVENT_ADMIN permission on the source 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 A file was uploaded.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Event not found.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - id:
	///     Unique identifier of the event.
	public func replaceEventAttachment(body: Data, id: String) -> AnyPublisher<C8yEventBinary, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/event/events/\(id)/binaries")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "text/plain")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.event+json")
			.set(httpBody: body)
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
		}).decode(type: C8yEventBinary.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Attach a file to a specific event
	/// 
	/// Upload a file (binary) as an attachment of a specific event by a given ID.
	/// The size of the attachment is configurable, and the default size is 50 MiB. The default chunk size is 5MiB.
	/// 
	/// After the file has been uploaded, the corresponding event will contain the fragment `c8y_IsBinary` similar to:
	/// 
	/// ```json
	/// "c8y_IsBinary": {
	///     "name": "hello.txt",
	///     "length": 365,
	///     "type": "text/plain"
	/// }
	/// ```
	/// When using `multipart/form-data` each value is sent as a block of data (body part), with a user agent-defined delimiter (`boundary`) separating each part. The keys are given in the `Content-Disposition` header of each part.
	/// 
	/// ```http
	/// POST /event/events/{id}/binaries
	/// Host: https://<TENANT_DOMAIN>
	/// Authorization: <AUTHORIZATION>
	/// Accept: application/json
	/// Content-Type: multipart/form-data;boundary="boundary"
	/// 
	/// --boundary
	/// Content-Disposition: form-data; name="object"
	/// 
	/// { "name": "hello.txt", "type": "text/plain" }
	/// --boundary
	/// Content-Disposition: form-data; name="file"; filename="hello.txt"
	/// Content-Type: text/plain
	/// 
	/// <FILE_CONTENTS>
	/// --boundary--
	/// ```
	/// 
	/// > Tip: Required roles
	///  ROLE_EVENT_ADMIN *OR* owner of the source *OR* EVENT_ADMIN permission on the source 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 A file was uploaded.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Event not found.
	/// * HTTP 409 An attachment exists already.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - id:
	///     Unique identifier of the event.
	public func uploadEventAttachment(body: Data, id: String) -> AnyPublisher<C8yEventBinary, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/event/events/\(id)/binaries")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "text/plain")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.event+json")
			.set(httpBody: body)
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
		}).decode(type: C8yEventBinary.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Attach a file to a specific event
	/// 
	/// Upload a file (binary) as an attachment of a specific event by a given ID.
	/// The size of the attachment is configurable, and the default size is 50 MiB. The default chunk size is 5MiB.
	/// 
	/// After the file has been uploaded, the corresponding event will contain the fragment `c8y_IsBinary` similar to:
	/// 
	/// ```json
	/// "c8y_IsBinary": {
	///     "name": "hello.txt",
	///     "length": 365,
	///     "type": "text/plain"
	/// }
	/// ```
	/// When using `multipart/form-data` each value is sent as a block of data (body part), with a user agent-defined delimiter (`boundary`) separating each part. The keys are given in the `Content-Disposition` header of each part.
	/// 
	/// ```http
	/// POST /event/events/{id}/binaries
	/// Host: https://<TENANT_DOMAIN>
	/// Authorization: <AUTHORIZATION>
	/// Accept: application/json
	/// Content-Type: multipart/form-data;boundary="boundary"
	/// 
	/// --boundary
	/// Content-Disposition: form-data; name="object"
	/// 
	/// { "name": "hello.txt", "type": "text/plain" }
	/// --boundary
	/// Content-Disposition: form-data; name="file"; filename="hello.txt"
	/// Content-Type: text/plain
	/// 
	/// <FILE_CONTENTS>
	/// --boundary--
	/// ```
	/// 
	/// > Tip: Required roles
	///  ROLE_EVENT_ADMIN *OR* owner of the source *OR* EVENT_ADMIN permission on the source 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 A file was uploaded.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Event not found.
	/// * HTTP 409 An attachment exists already.
	/// 
	/// - Parameters:
	///   - `object`:
	///     
	///   - file:
	///     Path of the file to be uploaded.
	///   - id:
	///     Unique identifier of the event.
	public func uploadEventAttachment(`object`: C8yBinaryInfo, file: Data, id: String) -> AnyPublisher<C8yEventBinary, Error> {
		let multipartBuilder = MultipartFormDataBuilder()
		do {
			try multipartBuilder.addBodyPart(named: "object", codable: `object`, mimeType: "application/json");
		} catch {
			return Fail<C8yEventBinary, Error>(error: error).eraseToAnyPublisher()
		}
		do {
			try multipartBuilder.addBodyPart(named: "file", codable: file, mimeType: "text/plain");
		} catch {
			return Fail<C8yEventBinary, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/event/events/\(id)/binaries")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "multipart/form-data")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.event+json")
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
		}).decode(type: C8yEventBinary.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove the attached file from a specific event
	/// 
	/// Remove the attached file (binary) from a specific event by a given ID.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_EVENT_ADMIN *OR* owner of the source *OR* EVENT_ADMIN permission on the source 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 A file was removed.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Event not found.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the event.
	public func deleteEventAttachment(id: String) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/event/events/\(id)/binaries")
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
