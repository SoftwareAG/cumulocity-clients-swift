//
// AttachmentsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// It is possible to store, retrieve and delete binaries for events. Each event can have one binary attached.
public class AttachmentsApi: AdaptableApi {

	/// Retrieve the attached file of a specific event
	/// Retrieve the attached file (binary) of a specific event by a given ID.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_EVENT_READ <b>OR</b> EVENT_READ permission on the source
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the file is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Attachment not found.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the event.
	public func getEventAttachment(id: String) -> AnyPublisher<Data, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/event/events/\(id)/binaries")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/octet-stream")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try! decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error401)
			}
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try! decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error404)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(response: httpResponse)
			}
			
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Replace the attached file of a specific event
	/// Upload and replace the attached file (binary) of a specific event by a given ID.<br>
	/// The size of the attachment is configurable, and the default size is 50 MiB. The default chunk size is 5MiB.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_EVENT_ADMIN <b>OR</b> owner of the source <b>OR</b> EVENT_ADMIN permission on the source
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  A file was uploaded.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Event not found.
	/// - Parameters:
	/// 	- body 
	/// 	- id 
	///		  Unique identifier of the event.
	public func replaceEventAttachment(body: Data, id: String) -> AnyPublisher<C8yEventBinary, Swift.Error> {
		let requestBody = body
		let encodedRequestBody = try? JSONEncoder().encode(requestBody)
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
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try! decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error401)
			}
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try! decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error404)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yEventBinary.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Attach a file to a specific event
	/// Upload a file (binary) as an attachment of a specific event by a given ID.<br>
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
	/// 
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
	/// <section><h5>Required roles</h5>
	/// ROLE_EVENT_ADMIN <b>OR</b> owner of the source <b>OR</b> EVENT_ADMIN permission on the source
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  A file was uploaded.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Event not found.
	/// 	- 409
	///		  An attachment exists already.
	/// - Parameters:
	/// 	- body 
	/// 	- id 
	///		  Unique identifier of the event.
	public func uploadEventAttachment(body: Data, id: String) -> AnyPublisher<C8yEventBinary, Swift.Error> {
		let requestBody = body
		let encodedRequestBody = try? JSONEncoder().encode(requestBody)
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
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try! decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error401)
			}
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try! decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error404)
			}
			guard httpResponse.statusCode != 409 else {
				let decoder = JSONDecoder()
				let error409 = try! decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error409)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yEventBinary.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Attach a file to a specific event
	/// Upload a file (binary) as an attachment of a specific event by a given ID.<br>
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
	/// 
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
	/// <section><h5>Required roles</h5>
	/// ROLE_EVENT_ADMIN <b>OR</b> owner of the source <b>OR</b> EVENT_ADMIN permission on the source
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  A file was uploaded.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Event not found.
	/// 	- 409
	///		  An attachment exists already.
	/// - Parameters:
	/// 	- `object` 
	/// 	- file 
	///		  Path of the file to be uploaded.
	/// 	- id 
	///		  Unique identifier of the event.
	public func uploadEventAttachment(`object`: C8yBinaryInfo, file: Data, id: String) -> AnyPublisher<C8yEventBinary, Swift.Error> {
		let multipartBuilder = MultipartFormDataBuilder()
		try? multipartBuilder.addBodyPart(named: "object", data: `object`, mimeType: "application/json");
		try? multipartBuilder.addBodyPart(named: "file", data: file, mimeType: "text/plain");
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
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try! decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error401)
			}
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try! decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error404)
			}
			guard httpResponse.statusCode != 409 else {
				let decoder = JSONDecoder()
				let error409 = try! decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error409)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yEventBinary.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove the attached file from a specific event
	/// Remove the attached file (binary) from a specific event by a given ID.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_EVENT_ADMIN <b>OR</b> owner of the source <b>OR</b> EVENT_ADMIN permission on the source
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  A file was removed.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Event not found.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the event.
	public func deleteEventAttachment(id: String) -> AnyPublisher<Data, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/event/events/\(id)/binaries")
			.set(httpMethod: "delete")
			.add(header: "Accept", value: "application/json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try! decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error401)
			}
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try! decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error404)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(response: httpResponse)
			}
			
			return element.data
		}).eraseToAnyPublisher()
	}
}
