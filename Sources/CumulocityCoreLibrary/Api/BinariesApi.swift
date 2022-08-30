//
// BinariesApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// Managed objects can perform operations to store, retrieve and delete binaries. One binary can store only one file. Together with the binary, a managed object is created which acts as a metadata information for the binary.
/// 
/// > **&#9432; Info:** The Accept header should be provided in all POST/PUT requests, otherwise an empty response body will be returned.
/// 
public class BinariesApi: AdaptableApi {

	/// Retrieve the stored files
	/// Retrieve the stored files as a collections of managed objects.
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the managed objects are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- childAdditionId 
	///		  Search for a specific child addition and list all the groups to which it belongs.
	/// 	- childAssetId 
	///		  Search for a specific child asset and list all the groups to which it belongs.
	/// 	- childDeviceId 
	///		  Search for a specific child device and list all the groups to which it belongs.
	/// 	- currentPage 
	///		  The current page of the paginated results.
	/// 	- ids 
	///		  The managed object IDs to search for (comma separated).
	/// 	- owner 
	///		  Username of the owner of the managed objects.
	/// 	- pageSize 
	///		  Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	/// 	- text 
	///		  Search for managed objects where any property value is equal to the given one. Only string values are supported.
	/// 	- type 
	///		  The type of managed object to search for.
	/// 	- withTotalPages 
	///		  When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getBinaries(childAdditionId: String? = nil, childAssetId: String? = nil, childDeviceId: String? = nil, currentPage: Int? = nil, ids: [String]? = nil, owner: String? = nil, pageSize: Int? = nil, text: String? = nil, type: String? = nil, withTotalPages: Bool? = nil) -> AnyPublisher<C8yBinaryCollection, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = childAdditionId { queryItems.append(URLQueryItem(name: "childAdditionId", value: String(parameter))) }
		if let parameter = childAssetId { queryItems.append(URLQueryItem(name: "childAssetId", value: String(parameter))) }
		if let parameter = childDeviceId { queryItems.append(URLQueryItem(name: "childDeviceId", value: String(parameter))) }
		if let parameter = currentPage { queryItems.append(URLQueryItem(name: "currentPage", value: String(parameter))) }
		if let parameter = ids { parameter.forEach{ p in queryItems.append(URLQueryItem(name: "ids", value: p)) } }
		if let parameter = owner { queryItems.append(URLQueryItem(name: "owner", value: String(parameter))) }
		if let parameter = pageSize { queryItems.append(URLQueryItem(name: "pageSize", value: String(parameter))) }
		if let parameter = text { queryItems.append(URLQueryItem(name: "text", value: String(parameter))) }
		if let parameter = type { queryItems.append(URLQueryItem(name: "type", value: String(parameter))) }
		if let parameter = withTotalPages { queryItems.append(URLQueryItem(name: "withTotalPages", value: String(parameter))) }
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/binaries")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.managedobjectcollection+json")
			.set(queryItems: queryItems)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try! decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error401)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yBinaryCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Upload a file
	/// Uploading a file (binary) requires providing the following properties:
	/// 
	/// * `object` – In JSON format, it contains information about the file.
	/// * `file` – Contains the file to be uploaded.
	/// 
	/// After the file has been uploaded, the corresponding managed object will contain the fragment `c8y_IsBinary`.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_ADMIN <b>OR</b> ROLE_INVENTORY_CREATE
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  A file was uploaded.
	/// 	- 400
	///		  Unprocessable Entity – invalid payload.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not authorized to perform this operation.
	/// - Parameters:
	/// 	- `object` 
	/// 	- file 
	///		  Path of the file to be uploaded.
	public func uploadBinary(`object`: C8yBinaryInfo, file: Data) -> AnyPublisher<C8yBinary, Swift.Error> {
		let multipartBuilder = MultipartFormDataBuilder()
		try? multipartBuilder.addBodyPart(named: "object", data: `object`, mimeType: "application/json");
		try? multipartBuilder.addBodyPart(named: "file", data: file, mimeType: "text/plain");
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/binaries")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "multipart/form-data")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.managedobject+json")
			.add(header: "Content-Type", value: multipartBuilder.contentType)
			.set(httpBody: multipartBuilder.build())
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 400 else {
				throw Errors.badResponseError(response: httpResponse, reason: "Unprocessable Entity – invalid payload.")
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try! decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error401)
			}
			guard httpResponse.statusCode != 403 else {
				throw Errors.badResponseError(response: httpResponse, reason: "Not authorized to perform this operation.")
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yBinary.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a stored file
	/// Retrieve a stored file (managed object) by a given ID.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_READ <b>OR</b> owner of the resource <b>OR</b> MANAGE_OBJECT_READ permission on the resource
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the file is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the managed object.
	public func getBinary(id: String) -> AnyPublisher<Data, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/binaries/\(id)")
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
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(response: httpResponse)
			}
			
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Replace a file
	/// Upload and replace the attached file (binary) of a specific managed object by a given ID.<br>
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_ADMIN <b>OR</b> owner of the resource <b>OR</b> MANAGE_OBJECT_ADMIN permission on the resource
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  A file was uploaded.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- body 
	/// 	- id 
	///		  Unique identifier of the managed object.
	public func replaceBinary(body: Data, id: String) -> AnyPublisher<C8yBinary, Swift.Error> {
		let requestBody = body
		let encodedRequestBody = try? JSONEncoder().encode(requestBody)
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/binaries/\(id)")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "text/plain")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.managedobject+json")
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
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yBinary.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove a stored file
	/// Remove a managed object and its stored file by a given ID.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_ADMIN <b>OR</b> owner of the resource <b>OR</b> MANAGE_OBJECT_ADMIN permission on the resource
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  A managed object and its stored file was removed.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the managed object.
	public func removeBinary(id: String) -> AnyPublisher<Data, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/binaries/\(id)")
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
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(response: httpResponse)
			}
			
			return element.data
		}).eraseToAnyPublisher()
	}
}
