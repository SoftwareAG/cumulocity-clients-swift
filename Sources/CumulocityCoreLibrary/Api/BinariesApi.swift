//
// BinariesApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// Managed objects can perform operations to store, retrieve and delete binaries. One binary can store only one file. Together with the binary, a managed object is created which acts as a metadata information for the binary.
/// 
/// > **ⓘ Note** The Accept header should be provided in all POST/PUT requests, otherwise an empty response body will be returned.
public class BinariesApi: AdaptableApi {

	/// Retrieve the stored files
	/// 
	/// Retrieve the stored files as a collections of managed objects.
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the managed objects are sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// 
	/// - Parameters:
	///   - childAdditionId:
	///     Search for a specific child addition and list all the groups to which it belongs.
	///   - childAssetId:
	///     Search for a specific child asset and list all the groups to which it belongs.
	///   - childDeviceId:
	///     Search for a specific child device and list all the groups to which it belongs.
	///   - currentPage:
	///     The current page of the paginated results.
	///   - ids:
	///     The managed object IDs to search for.
	///     
	///     **ⓘ Note** If you query for multiple IDs at once, comma-separate the values.
	///   - owner:
	///     Username of the owner of the managed objects.
	///   - pageSize:
	///     Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	///   - text:
	///     Search for managed objects where any property value is equal to the given one. Only string values are supported.
	///   - type:
	///     The type of managed object to search for.
	///   - withTotalPages:
	///     When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getBinaries(childAdditionId: String? = nil, childAssetId: String? = nil, childDeviceId: String? = nil, currentPage: Int? = nil, ids: [String]? = nil, owner: String? = nil, pageSize: Int? = nil, text: String? = nil, type: String? = nil, withTotalPages: Bool? = nil) -> AnyPublisher<C8yBinaryCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/binaries")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.managedobjectcollection+json")
			.add(queryItem: "childAdditionId", value: childAdditionId)
			.add(queryItem: "childAssetId", value: childAssetId)
			.add(queryItem: "childDeviceId", value: childDeviceId)
			.add(queryItem: "currentPage", value: currentPage)
			.add(queryItem: "ids", value: ids, explode: .comma_separated)
			.add(queryItem: "owner", value: owner)
			.add(queryItem: "pageSize", value: pageSize)
			.add(queryItem: "text", value: text)
			.add(queryItem: "type", value: type)
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
		}).decode(type: C8yBinaryCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Upload a file
	/// 
	/// Uploading a file (binary) requires providing the following properties:
	/// 
	/// * `object` – In JSON format, it contains information about the file.
	/// * `file` – Contains the file to be uploaded.
	/// 
	/// After the file has been uploaded, the corresponding managed object will contain the fragment `c8y_IsBinary`.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_ADMIN *OR* ROLE_INVENTORY_CREATE 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 A file was uploaded.
	/// * HTTP 400 Unprocessable Entity – invalid payload.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// 
	/// - Parameters:
	///   - `object`:
	///     
	///   - file:
	///     Path of the file to be uploaded.
	public func uploadBinary(`object`: C8yBinaryInfo, file: Data) -> AnyPublisher<C8yBinary, Error> {
		let multipartBuilder = MultipartFormDataBuilder()
		do {
			try multipartBuilder.addBodyPart(named: "object", codable: `object`, mimeType: "application/json");
		} catch {
			return Fail<C8yBinary, Error>(error: error).eraseToAnyPublisher()
		}
		do {
			try multipartBuilder.addBodyPart(named: "file", codable: file, mimeType: "text/plain");
		} catch {
			return Fail<C8yBinary, Error>(error: error).eraseToAnyPublisher()
		}
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
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).decode(type: C8yBinary.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a stored file
	/// 
	/// Retrieve a stored file (managed object) by a given ID.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_READ *OR* owner of the resource *OR* MANAGE_OBJECT_READ permission on the resource 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the file is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the managed object.
	public func getBinary(id: String) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/binaries/\(id)")
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
	
	/// Replace a file
	/// 
	/// Upload and replace the attached file (binary) of a specific managed object by a given ID.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_ADMIN *OR* owner of the resource *OR* MANAGE_OBJECT_ADMIN permission on the resource 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 A file was uploaded.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - id:
	///     Unique identifier of the managed object.
	public func replaceBinary(body: Data, id: String) -> AnyPublisher<C8yBinary, Error> {
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
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).decode(type: C8yBinary.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove a stored file
	/// 
	/// Remove a managed object and its stored file by a given ID.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_ADMIN *OR* owner of the resource *OR* MANAGE_OBJECT_ADMIN permission on the resource 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 A managed object and its stored file was removed.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the managed object.
	public func removeBinary(id: String) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/binaries/\(id)")
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
