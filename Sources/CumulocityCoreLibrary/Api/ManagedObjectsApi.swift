//
// ManagedObjectsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// The inventory stores devices and other assets relevant to your IoT solution. We refer to them as managed objects and such can be “smart objects”, for example, smart electricity meters, home automation gateways or GPS devices.
/// 
/// > **&#9432; Info:** The Accept header should be provided in all POST/PUT requests, otherwise an empty response body will be returned.
/// 
public class ManagedObjectsApi: AdaptableApi {

	/// Retrieve all managed objects
	/// Retrieve all managed objects (for example, devices, assets, etc.) registered in your tenant, or a subset based on queries.
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the collection of objects is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 422
	///		  Invalid data was sent.
	/// - Parameters:
	/// 	- childAdditionId 
	///		  Search for a specific child addition and list all the groups to which it belongs.
	/// 	- childAssetId 
	///		  Search for a specific child asset and list all the groups to which it belongs.
	/// 	- childDeviceId 
	///		  Search for a specific child device and list all the groups to which it belongs.
	/// 	- currentPage 
	///		  The current page of the paginated results.
	/// 	- fragmentType 
	///		  A characteristic which identifies a managed object or event, for example, geolocation, electricity sensor, relay state.
	/// 	- ids 
	///		  The managed object IDs to search for (comma separated).
	/// 	- onlyRoots 
	///		  When set to `true` it returns managed objects which don't have any parent. If the current user doesn't have access to the parent, this is also root for the user.
	/// 	- owner 
	///		  Username of the owner of the managed objects.
	/// 	- pageSize 
	///		  Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	/// 	- q 
	///		  Similar to the parameter `query`, but it assumes that this is a device query request and it adds automatically the search criteria `fragmentType=c8y_IsDevice`.
	/// 	- query 
	///		  Use query language to perform operations and/or filter the results. Details about the properties and supported operations can be found in [Query language](#tag/Query-language).
	/// 	- skipChildrenNames 
	///		  When set to true, the returned references of child devices won't contain their names.
	/// 	- text 
	///		  Search for managed objects where any property value is equal to the given one. Only string values are supported.
	/// 	- type 
	///		  The type of managed object to search for.
	/// 	- withChildren 
	///		  Determines if children with ID and name should be returned when fetching the managed object. Set it to false to improve query performance.
	/// 	- withGroups 
	///		  When set to `true` it returns additional information about the groups to which the searched managed object belongs. This results in setting the `assetParents` property with additional information about the groups.
	/// 	- withParents 
	///		  When set to true, the returned references of child parents will return the device's parents (if any). Otherwise, it will be an empty array.
	/// 	- withTotalPages 
	///		  When set to true, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getManagedObjects(childAdditionId: String? = nil, childAssetId: String? = nil, childDeviceId: String? = nil, currentPage: Int? = nil, fragmentType: String? = nil, ids: String? = nil, onlyRoots: Bool? = nil, owner: String? = nil, pageSize: Int? = nil, q: String? = nil, query: String? = nil, skipChildrenNames: Bool? = nil, text: String? = nil, type: String? = nil, withChildren: Bool? = nil, withGroups: Bool? = nil, withParents: Bool? = nil, withTotalPages: Bool? = nil) throws -> AnyPublisher<C8yManagedObjectCollection, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = childAdditionId { queryItems.append(URLQueryItem(name: "childAdditionId", value: String(parameter)))}
		if let parameter = childAssetId { queryItems.append(URLQueryItem(name: "childAssetId", value: String(parameter)))}
		if let parameter = childDeviceId { queryItems.append(URLQueryItem(name: "childDeviceId", value: String(parameter)))}
		if let parameter = currentPage { queryItems.append(URLQueryItem(name: "currentPage", value: String(parameter)))}
		if let parameter = fragmentType { queryItems.append(URLQueryItem(name: "fragmentType", value: String(parameter)))}
		if let parameter = ids { queryItems.append(URLQueryItem(name: "ids", value: String(parameter)))}
		if let parameter = onlyRoots { queryItems.append(URLQueryItem(name: "onlyRoots", value: String(parameter)))}
		if let parameter = owner { queryItems.append(URLQueryItem(name: "owner", value: String(parameter)))}
		if let parameter = pageSize { queryItems.append(URLQueryItem(name: "pageSize", value: String(parameter)))}
		if let parameter = q { queryItems.append(URLQueryItem(name: "q", value: String(parameter)))}
		if let parameter = query { queryItems.append(URLQueryItem(name: "query", value: String(parameter)))}
		if let parameter = skipChildrenNames { queryItems.append(URLQueryItem(name: "skipChildrenNames", value: String(parameter)))}
		if let parameter = text { queryItems.append(URLQueryItem(name: "text", value: String(parameter)))}
		if let parameter = type { queryItems.append(URLQueryItem(name: "type", value: String(parameter)))}
		if let parameter = withChildren { queryItems.append(URLQueryItem(name: "withChildren", value: String(parameter)))}
		if let parameter = withGroups { queryItems.append(URLQueryItem(name: "withGroups", value: String(parameter)))}
		if let parameter = withParents { queryItems.append(URLQueryItem(name: "withParents", value: String(parameter)))}
		if let parameter = withTotalPages { queryItems.append(URLQueryItem(name: "withTotalPages", value: String(parameter)))}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.managedobjectcollection+json")
			.set(queryItems: queryItems)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yManagedObjectCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create a managed object
	/// Create a managed object, for example, a device with temperature measurements support or a binary switch.<br>
	/// In general, each managed object may consist of:
	/// 
	/// *  A unique identifier that references the object.
	/// *  The name of the object.
	/// *  The most specific type of the managed object.
	/// *  A time stamp showing the last update.
	/// *  Fragments with specific meanings, for example, `c8y_IsDevice`, `c8y_SupportedOperations`.
	/// *  Any additional custom fragments.
	/// 
	/// Imagine, for example, that you want to describe electric meters from different vendors. Depending on the make of the meter, one may have a relay and one may be capable to measure a single phase or three phases (for example, a three-phase electricity sensor). A fragment `c8y_ThreePhaseElectricitySensor` would identify such an electric meter. Devices' characteristics are identified by storing fragments for each of them.
	/// 
	/// > **&#9432; Info:** For more details about fragments with specific meanings, review the sections [Device management library](#section/Device-management-library) and [Sensor library](#section/Sensor-library).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_ADMIN <b>OR</b> ROLE_INVENTORY_CREATE
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  A managed object was created.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 422
	///		  Unprocessable Entity – invalid payload.
	/// - Parameters:
	/// 	- body 
	public func createManagedObject(body: C8yManagedObject) throws -> AnyPublisher<C8yManagedObject, Swift.Error> {
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
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobject+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.managedobject+json")
			.set(httpBody: try JSONEncoder().encode(requestBody))
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yManagedObject.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve the total number of managed objects
	/// Retrieve the total number of managed objects (for example, devices, assets, etc.) registered in your tenant, or a subset based on queries.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_READ is not required, but if the current user doesn't have this role, the response will contain the number of inventory objects accessible for the user.
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the number of managed objects is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- childAdditionId 
	///		  Search for a specific child addition and list all the groups to which it belongs.
	/// 	- childAssetId 
	///		  Search for a specific child asset and list all the groups to which it belongs.
	/// 	- childDeviceId 
	///		  Search for a specific child device and list all the groups to which it belongs.
	/// 	- fragmentType 
	///		  A characteristic which identifies a managed object or event, for example, geolocation, electricity sensor, relay state.
	/// 	- ids 
	///		  The managed object IDs to search for (comma separated).
	/// 	- owner 
	///		  Username of the owner of the managed objects.
	/// 	- text 
	///		  Search for managed objects where any property value is equal to the given one. Only string values are supported.
	/// 	- type 
	///		  The type of managed object to search for.
	public func getNumberOfManagedObjects(childAdditionId: String? = nil, childAssetId: String? = nil, childDeviceId: String? = nil, fragmentType: String? = nil, ids: String? = nil, owner: String? = nil, text: String? = nil, type: String? = nil) throws -> AnyPublisher<Int, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = childAdditionId { queryItems.append(URLQueryItem(name: "childAdditionId", value: String(parameter)))}
		if let parameter = childAssetId { queryItems.append(URLQueryItem(name: "childAssetId", value: String(parameter)))}
		if let parameter = childDeviceId { queryItems.append(URLQueryItem(name: "childDeviceId", value: String(parameter)))}
		if let parameter = fragmentType { queryItems.append(URLQueryItem(name: "fragmentType", value: String(parameter)))}
		if let parameter = ids { queryItems.append(URLQueryItem(name: "ids", value: String(parameter)))}
		if let parameter = owner { queryItems.append(URLQueryItem(name: "owner", value: String(parameter)))}
		if let parameter = text { queryItems.append(URLQueryItem(name: "text", value: String(parameter)))}
		if let parameter = type { queryItems.append(URLQueryItem(name: "type", value: String(parameter)))}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/count")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, text/plain,application/json")
			.set(queryItems: queryItems)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: Int.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific managed object
	/// Retrieve a specific managed object (for example, device, group, template) by a given ID.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_READ <b>OR</b> owner of the source <b>OR</b> MANAGE_OBJECT_READ permission on the source
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the object is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the managed object.
	/// 	- skipChildrenNames 
	///		  When set to true, the returned references of child devices won't contain their names.
	/// 	- withChildren 
	///		  Determines if children with ID and name should be returned when fetching the managed object. Set it to false to improve query performance.
	/// 	- withParents 
	///		  When set to true, the returned references of child parents will return the device's parents (if any). Otherwise, it will be an empty array.
	public func getManagedObject(id: String, skipChildrenNames: Bool? = nil, withChildren: Bool? = nil, withParents: Bool? = nil) throws -> AnyPublisher<C8yManagedObject, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = skipChildrenNames { queryItems.append(URLQueryItem(name: "skipChildrenNames", value: String(parameter)))}
		if let parameter = withChildren { queryItems.append(URLQueryItem(name: "withChildren", value: String(parameter)))}
		if let parameter = withParents { queryItems.append(URLQueryItem(name: "withParents", value: String(parameter)))}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.managedobject+json")
			.set(queryItems: queryItems)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yManagedObject.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update a specific managed object
	/// Update a specific managed object (for example, device) by a given ID.
	/// 
	/// For example, if you want to specify that your managed object is a device, you must add the fragment `c8y_IsDevice`.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_ADMIN <b>OR</b> owner of the source <b>OR</b> MANAGE_OBJECT_ADMIN permission on the source
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  A managed object was updated.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// - Parameters:
	/// 	- body 
	/// 	- id 
	///		  Unique identifier of the managed object.
	public func updateManagedObject(body: C8yManagedObject, id: String) throws -> AnyPublisher<C8yManagedObject, Swift.Error> {
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
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobject+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.managedobject+json")
			.set(httpBody: try JSONEncoder().encode(requestBody))
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yManagedObject.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove a specific managed object
	/// Remove a specific managed object (for example, device) by a given ID.
	/// 
	/// > **&#9432; Info:** Inventory DELETE requests are not synchronous. The response could be returned before the delete request has been completed. This may happen especially when the deleted managed object has a lot of associated data. After sending the request, the platform starts deleting the associated data in an asynchronous way. Finally, the requested managed object is deleted after all associated data has been deleted.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_ADMIN <b>OR</b> owner of the source <b>OR</b> MANAGE_OBJECT_ADMIN permission on the source
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  A managed object was removed.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the managed object.
	/// 	- cascade 
	///		  When set to `true` and the managed object is a device or group, all the hierarchy will be deleted.
	/// 	- forceCascade 
	///		  When set to `true` all the hierarchy will be deleted without checking the type of managed object. It takes precedence over the parameter `cascade`.
	/// 	- withDeviceUser 
	///		  When set to `true` and the managed object is a device, it deletes the associated device user (credentials).
	public func deleteManagedObject(id: String, cascade: Bool? = nil, forceCascade: Bool? = nil, withDeviceUser: Bool? = nil) throws -> AnyPublisher<Data, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = cascade { queryItems.append(URLQueryItem(name: "cascade", value: String(parameter)))}
		if let parameter = forceCascade { queryItems.append(URLQueryItem(name: "forceCascade", value: String(parameter)))}
		if let parameter = withDeviceUser { queryItems.append(URLQueryItem(name: "withDeviceUser", value: String(parameter)))}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)")
			.set(httpMethod: "delete")
			.add(header: "Accept", value: "application/json")
			.set(queryItems: queryItems)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Retrieve the latest availability date of a specific managed object
	/// Retrieve the date when a specific managed object (by a given ID) sent the last message to Cumulocity IoT.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_READ
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the date is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the managed object.
	public func getLatestAvailability(id: String) throws -> AnyPublisher<String, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/availability")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, text/plain, application/json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: String.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve all supported measurement fragments of a specific managed object
	/// Retrieve all measurement types of a specific managed object by a given ID.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_READ <b>OR</b> owner of the source <b>OR</b> MANAGE_OBJECT_READ permission on the source
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and all measurement types are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the managed object.
	public func getSupportedMeasurements(id: String) throws -> AnyPublisher<C8ySupportedMeasurements, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/supportedMeasurements")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8ySupportedMeasurements.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve all supported measurement fragments and series of a specific managed object
	/// Retrieve all supported measurement fragments and series of a specific managed object by a given ID.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_READ <b>OR</b> owner of the source <b>OR</b> MANAGE_OBJECT_READ permission on the source
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and all supported measurement series are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the managed object.
	public func getSupportedSeries(id: String) throws -> AnyPublisher<C8ySupportedSeries, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/supportedSeries")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8ySupportedSeries.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve the username and state of a specific managed object
	/// Retrieve the device owner's username and state (enabled or disabled) of a specific managed object (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_READ <b>OR</b> owner of the source <b>OR</b> MANAGE_OBJECT_READ permission on the source
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the username and state are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the managed object.
	public func getManagedObjectUser(id: String) throws -> AnyPublisher<C8yManagedObjectUser, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/user")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.managedobjectuser+json, application/vnd.com.nsn.cumulocity.error+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yManagedObjectUser.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update the user's details of a specific managed object
	/// Update the device owner's state (enabled or disabled) of a specific managed object (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_ADMIN <b>OR</b> owner of the source <b>OR</b> MANAGE_OBJECT_ADMIN permission on the source
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The user's details of a specific managed object were updated.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// - Parameters:
	/// 	- body 
	/// 	- id 
	///		  Unique identifier of the managed object.
	public func updateManagedObjectUser(body: C8yManagedObjectUser, id: String) throws -> AnyPublisher<C8yManagedObjectUser, Swift.Error> {
		var requestBody = body
		requestBody.`self` = nil
		requestBody.userName = nil
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/user")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobjectuser+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.managedobjectuser+json, application/vnd.com.nsn.cumulocity.error+json")
			.set(httpBody: try JSONEncoder().encode(requestBody))
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yManagedObjectUser.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
