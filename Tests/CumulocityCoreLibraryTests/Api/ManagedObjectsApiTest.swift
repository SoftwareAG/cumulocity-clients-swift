//
// ManagedObjectsApiTest.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Combine
import XCTest

@testable import CumulocityCoreLibrary

public class ManagedObjectsApiTest: XCTestCase {
	
	class TestableManagedObjectsApi: ManagedObjectsApi {

		override func adapt(builder: URLRequestBuilder) -> URLRequestBuilder {
			guard let testDataUrl = Bundle.module.path(forResource: "TestData", ofType: "plist") else { return builder }
			let resources = NSDictionary(contentsOfFile: testDataUrl)
			let scheme = resources["Scheme"] as? String ?? ""
			let hostName = resources["HostName"] as? String ?? ""
			let authorization = resources["Authorization"] as? String ?? ""
			return builder.set(scheme: scheme)
				.set(host: hostName)
				.add(header: "Authorization", value: authorization)
		}
	}

	public func testGetManagedObjects() {
		let expectation = XCTestExpectation(description: "ok")
		var cancellables = Set<AnyCancellable>()
		try? TestableManagedObjectsApi().getManagedObjects().sink(receiveCompletion: { completion in
			let message = try? completion.error()
			print(message?.statusCode ?? "Successfully")
		}, receiveValue: { data in
			expectation.fulfill()
			print(data)
		}).store(in: &cancellables)
		wait(for: [expectation], timeout: 10)
	}
	
	public func testGetNumberOfManagedObjects() {
		let expectation = XCTestExpectation(description: "ok")
		var cancellables = Set<AnyCancellable>()
		try? TestableManagedObjectsApi().getNumberOfManagedObjects().sink(receiveCompletion: { completion in
			let message = try? completion.error()
			print(message?.statusCode ?? "Successfully")
		}, receiveValue: { data in
			expectation.fulfill()
			print(data)
		}).store(in: &cancellables)
		wait(for: [expectation], timeout: 10)
	}
}
