//
// ManagedObjectsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// The inventory stores devices and other assets relevant to your IoT solution. We refer to them as managed objects and such can be “smart objects”, for example, smart electricity meters, home automation gateways or GPS devices.
/// 
/// > **ⓘ Note** The Accept header should be provided in all POST/PUT requests, otherwise an empty response body will be returned.
public class ManagedObjectsApi: AdaptableApi {

	/// Retrieve all managed objects
	/// 
	/// Retrieve all managed objects (for example, devices, assets, etc.) registered in your tenant, or a subset based on queries.
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the collection of objects is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 422 Invalid data was sent.
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
	///   - fragmentType:
	///     A characteristic which identifies a managed object or event, for example, geolocation, electricity sensor, relay state.
	///   - ids:
	///     The managed object IDs to search for.
	///     
	///     **ⓘ Note** If you query for multiple IDs at once, comma-separate the values.
	///   - onlyRoots:
	///     When set to `true` it returns managed objects which don't have any parent. If the current user doesn't have access to the parent, this is also root for the user.
	///   - owner:
	///     Username of the owner of the managed objects.
	///   - pageSize:
	///     Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	///   - q:
	///     Similar to the parameter `query`, but it assumes that this is a device query request and it adds automatically the search criteria `fragmentType=c8y_IsDevice`.
	///   - query:
	///     Use query language to perform operations and/or filter the results. Details about the properties and supported operations can be found in [Query language](#tag/Query-language).
	///   - skipChildrenNames:
	///     When set to `true`, the returned references of child devices won't contain their names.
	///   - text:
	///     Search for managed objects where any property value is equal to the given one. Only string values are supported.
	///   - type:
	///     The type of managed object to search for.
	///   - withChildren:
	///     Determines if children with ID and name should be returned when fetching the managed object. Set it to `false` to improve query performance.
	///   - withChildrenCount:
	///     When set to `true`, the returned result will contain the total number of children in the respective objects (`childAdditions`, `childAssets` and `childDevices`).
	///   - withGroups:
	///     When set to `true` it returns additional information about the groups to which the searched managed object belongs. This results in setting the `assetParents` property with additional information about the groups.
	///   - withParents:
	///     When set to `true`, the returned references of child parents will return the device's parents (if any). Otherwise, it will be an empty array.
	///   - withTotalElements:
	///     When set to `true`, the returned result will contain in the statistics object the total number of elements. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	///   - withTotalPages:
	///     When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getManagedObjects(childAdditionId: String? = nil, childAssetId: String? = nil, childDeviceId: String? = nil, currentPage: Int? = nil, fragmentType: String? = nil, ids: [String]? = nil, onlyRoots: Bool? = nil, owner: String? = nil, pageSize: Int? = nil, q: String? = nil, query: String? = nil, skipChildrenNames: Bool? = nil, text: String? = nil, type: String? = nil, withChildren: Bool? = nil, withChildrenCount: Bool? = nil, withGroups: Bool? = nil, withParents: Bool? = nil, withTotalElements: Bool? = nil, withTotalPages: Bool? = nil) -> AnyPublisher<C8yManagedObjectCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.managedobjectcollection+json")
			.add(queryItem: "childAdditionId", value: childAdditionId)
			.add(queryItem: "childAssetId", value: childAssetId)
			.add(queryItem: "childDeviceId", value: childDeviceId)
			.add(queryItem: "currentPage", value: currentPage)
			.add(queryItem: "fragmentType", value: fragmentType)
			.add(queryItem: "ids", value: ids, explode: .comma_separated)
			.add(queryItem: "onlyRoots", value: onlyRoots)
			.add(queryItem: "owner", value: owner)
			.add(queryItem: "pageSize", value: pageSize)
			.add(queryItem: "q", value: q)
			.add(queryItem: "query", value: query)
			.add(queryItem: "skipChildrenNames", value: skipChildrenNames)
			.add(queryItem: "text", value: text)
			.add(queryItem: "type", value: type)
			.add(queryItem: "withChildren", value: withChildren)
			.add(queryItem: "withChildrenCount", value: withChildrenCount)
			.add(queryItem: "withGroups", value: withGroups)
			.add(queryItem: "withParents", value: withParents)
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
		}).decode(type: C8yManagedObjectCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create a managed object
	/// 
	/// Create a managed object, for example, a device with temperature measurements support or a binary switch.
	/// In general, each managed object may consist of:
	/// 
	/// * A unique identifier that references the object.
	/// * The name of the object.
	/// * The most specific type of the managed object.
	/// * A time stamp showing the last update.
	/// * Fragments with specific meanings, for example, `c8y_IsDevice`, `c8y_SupportedOperations`.
	/// * Any additional custom fragments.
	/// 
	/// Imagine, for example, that you want to describe electric meters from different vendors. Depending on the make of the meter, one may have a relay and one may be capable to measure a single phase or three phases (for example, a three-phase electricity sensor). A fragment `c8y_ThreePhaseElectricitySensor` would identify such an electric meter. Devices' characteristics are identified by storing fragments for each of them.
	/// 
	/// > **ⓘ Note** For more details about fragments with specific meanings, review the sections [Device management library](#section/Device-management-library) and [Sensor library](#section/Sensor-library).
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_ADMIN *OR* ROLE_INVENTORY_CREATE 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 A managed object was created.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 422 Unprocessable Entity – invalid payload.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func createManagedObject(body: C8yManagedObject, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<C8yManagedObject, Error> {
		var requestBody = body
		requestBody.owner = nil
		requestBody.additionParents = nil
		requestBody.lastUpdated = nil
		requestBody.childDevices = nil
		requestBody.childAssets = nil
		requestBody.creationTime = nil
		requestBody.childAdditions = nil
		requestBody.`self` = nil
		requestBody.assetParents = nil
		requestBody.deviceParents = nil
		requestBody.id = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yManagedObject, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects")
			.set(httpMethod: "post")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobject+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.managedobject+json")
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
		}).decode(type: C8yManagedObject.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve the total number of managed objects
	/// 
	/// Retrieve the total number of managed objects (for example, devices, assets, etc.) registered in your tenant, or a subset based on queries.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_READ is not required, but if the current user doesn't have this role, the response will contain the number of inventory objects accessible for the user. 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the number of managed objects is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// 
	/// - Parameters:
	///   - childAdditionId:
	///     Search for a specific child addition and list all the groups to which it belongs.
	///   - childAssetId:
	///     Search for a specific child asset and list all the groups to which it belongs.
	///   - childDeviceId:
	///     Search for a specific child device and list all the groups to which it belongs.
	///   - fragmentType:
	///     A characteristic which identifies a managed object or event, for example, geolocation, electricity sensor, relay state.
	///   - ids:
	///     The managed object IDs to search for.
	///     
	///     **ⓘ Note** If you query for multiple IDs at once, comma-separate the values.
	///   - owner:
	///     Username of the owner of the managed objects.
	///   - text:
	///     Search for managed objects where any property value is equal to the given one. Only string values are supported.
	///   - type:
	///     The type of managed object to search for.
	public func getNumberOfManagedObjects(childAdditionId: String? = nil, childAssetId: String? = nil, childDeviceId: String? = nil, fragmentType: String? = nil, ids: [String]? = nil, owner: String? = nil, text: String? = nil, type: String? = nil) -> AnyPublisher<Int, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/count")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, text/plain,application/json")
			.add(queryItem: "childAdditionId", value: childAdditionId)
			.add(queryItem: "childAssetId", value: childAssetId)
			.add(queryItem: "childDeviceId", value: childDeviceId)
			.add(queryItem: "fragmentType", value: fragmentType)
			.add(queryItem: "ids", value: ids, explode: .comma_separated)
			.add(queryItem: "owner", value: owner)
			.add(queryItem: "text", value: text)
			.add(queryItem: "type", value: type)
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
		}).decode(type: Int.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific managed object
	/// 
	/// Retrieve a specific managed object (for example, device, group, template) by a given ID.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_READ *OR* owner of the source *OR* MANAGE_OBJECT_READ permission on the source 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the object is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the managed object.
	///   - skipChildrenNames:
	///     When set to `true`, the returned references of child devices won't contain their names.
	///   - withChildren:
	///     Determines if children with ID and name should be returned when fetching the managed object. Set it to `false` to improve query performance.
	///   - withChildrenCount:
	///     When set to `true`, the returned result will contain the total number of children in the respective objects (`childAdditions`, `childAssets` and `childDevices`).
	///   - withParents:
	///     When set to `true`, the returned references of child parents will return the device's parents (if any). Otherwise, it will be an empty array.
	public func getManagedObject(id: String, skipChildrenNames: Bool? = nil, withChildren: Bool? = nil, withChildrenCount: Bool? = nil, withParents: Bool? = nil) -> AnyPublisher<C8yManagedObject, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.managedobject+json")
			.add(queryItem: "skipChildrenNames", value: skipChildrenNames)
			.add(queryItem: "withChildren", value: withChildren)
			.add(queryItem: "withChildrenCount", value: withChildrenCount)
			.add(queryItem: "withParents", value: withParents)
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
		}).decode(type: C8yManagedObject.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update a specific managed object
	/// 
	/// Update a specific managed object (for example, device) by a given ID.
	/// 
	/// For example, if you want to specify that your managed object is a device, you must add the fragment `c8y_IsDevice`.
	/// 
	/// The endpoint can also be used as a device availability heartbeat.If you only specifiy the `id`, it updates the date when the last message was received and no other property.The response then only contains the `id` instead of the full managed object.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_ADMIN *OR* owner of the source *OR* MANAGE_OBJECT_ADMIN permission on the source 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 A managed object was updated.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - id:
	///     Unique identifier of the managed object.
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func updateManagedObject(body: C8yManagedObject, id: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<C8yManagedObject, Error> {
		var requestBody = body
		requestBody.owner = nil
		requestBody.additionParents = nil
		requestBody.lastUpdated = nil
		requestBody.childDevices = nil
		requestBody.childAssets = nil
		requestBody.creationTime = nil
		requestBody.childAdditions = nil
		requestBody.`self` = nil
		requestBody.assetParents = nil
		requestBody.deviceParents = nil
		requestBody.id = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yManagedObject, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)")
			.set(httpMethod: "put")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobject+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.managedobject+json")
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
		}).decode(type: C8yManagedObject.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove a specific managed object
	/// 
	/// Remove a specific managed object (for example, device) by a given ID.
	/// 
	/// > **ⓘ Note** Inventory DELETE requests are not synchronous. The response could be returned before the delete request has been completed. This may happen especially when the deleted managed object has a lot of associated data. After sending the request, the platform starts deleting the associated data in an asynchronous way. Finally, the requested managed object is deleted after all associated data has been deleted.
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_ADMIN *OR* owner of the source *OR* MANAGE_OBJECT_ADMIN permission on the source 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 A managed object was removed.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// * HTTP 409 Conflict – The managed object is associated to other objects, for example child devices.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the managed object.
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	///   - cascade:
	///     When set to `true` and the managed object is a device or group, all the hierarchy will be deleted.
	///   - forceCascade:
	///     When set to `true` all the hierarchy will be deleted without checking the type of managed object. It takes precedence over the parameter `cascade`.
	///   - withDeviceUser:
	///     When set to `true` and the managed object is a device, it deletes the associated device user (credentials).
	public func deleteManagedObject(id: String, xCumulocityProcessingMode: String? = nil, cascade: Bool? = nil, forceCascade: Bool? = nil, withDeviceUser: Bool? = nil) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)")
			.set(httpMethod: "delete")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Accept", value: "application/json")
			.add(queryItem: "cascade", value: cascade)
			.add(queryItem: "forceCascade", value: forceCascade)
			.add(queryItem: "withDeviceUser", value: withDeviceUser)
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
	
	/// Retrieve the latest availability date of a specific managed object
	/// 
	/// Retrieve the date when a specific managed object (by a given ID) sent the last message to Cumulocity IoT.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_READ 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the date is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the managed object.
	public func getLatestAvailability(id: String) -> AnyPublisher<String, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/availability")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, text/plain, application/json")
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
		}).decode(type: String.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve all supported measurement fragments of a specific managed object
	/// 
	/// Retrieve all measurement types of a specific managed object by a given ID.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_READ *OR* owner of the source *OR* MANAGE_OBJECT_READ permission on the source 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and all measurement types are sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the managed object.
	public func getSupportedMeasurements(id: String) -> AnyPublisher<C8ySupportedMeasurements, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/supportedMeasurements")
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
		}).decode(type: C8ySupportedMeasurements.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve all supported measurement fragments and series of a specific managed object
	/// 
	/// Retrieve all supported measurement fragments and series of a specific managed object by a given ID.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_READ *OR* owner of the source *OR* MANAGE_OBJECT_READ permission on the source 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and all supported measurement series are sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the managed object.
	public func getSupportedSeries(id: String) -> AnyPublisher<C8ySupportedSeries, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/supportedSeries")
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
		}).decode(type: C8ySupportedSeries.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve the username and state of a specific managed object
	/// 
	/// Retrieve the device owner's username and state (enabled or disabled) of a specific managed object (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_READ *OR* owner of the source *OR* MANAGE_OBJECT_READ permission on the source 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the username and state are sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the managed object.
	public func getManagedObjectUser(id: String) -> AnyPublisher<C8yManagedObjectUser, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/user")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.managedobjectuser+json, application/vnd.com.nsn.cumulocity.error+json")
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
		}).decode(type: C8yManagedObjectUser.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update the user's details of a specific managed object
	/// 
	/// Update the device owner's state (enabled or disabled) of a specific managed object (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_ADMIN *OR* owner of the source *OR* MANAGE_OBJECT_ADMIN permission on the source 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The user's details of a specific managed object were updated.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - id:
	///     Unique identifier of the managed object.
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func updateManagedObjectUser(body: C8yManagedObjectUser, id: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<C8yManagedObjectUser, Error> {
		var requestBody = body
		requestBody.`self` = nil
		requestBody.userName = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yManagedObjectUser, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/user")
			.set(httpMethod: "put")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobjectuser+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.managedobjectuser+json, application/vnd.com.nsn.cumulocity.error+json")
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
		}).decode(type: C8yManagedObjectUser.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
