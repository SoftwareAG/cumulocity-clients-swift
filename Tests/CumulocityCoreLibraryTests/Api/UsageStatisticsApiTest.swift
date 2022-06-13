//
// UsageStatisticsApiTest.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Combine
import XCTest

@testable import CumulocityCoreLibrary

public class UsageStatisticsApiTest: XCTestCase {
	
	class TestableUsageStatisticsApi: UsageStatisticsApi {

		override func adapt(builder: URLRequestBuilder) -> URLRequestBuilder {
			return builder.set(scheme: "https")
				.set(host: "iotaccstage2.eu-latest.cumulocity.com")
				.add(header: "Authorization", value: "Basic bW9iaWxlOm1vYmlsZTAxJA==")
		}
	}

	public func testGetTenantUsageStatisticsCollectionResource() {
		let expectation = XCTestExpectation(description: "ok")
		var cancellables = Set<AnyCancellable>()
		try? TestableUsageStatisticsApi().getTenantUsageStatisticsCollectionResource().sink(receiveCompletion: { completion in
			print(completion)
		}, receiveValue: { data in
			expectation.fulfill()
			print(data)
		}).store(in: &cancellables)
		wait(for: [expectation], timeout: 10)
	}
	
	public func testGetTenantUsageStatistics() {
		let expectation = XCTestExpectation(description: "ok")
		var cancellables = Set<AnyCancellable>()
		try? TestableUsageStatisticsApi().getTenantUsageStatistics().sink(receiveCompletion: { completion in
			print(completion)
		}, receiveValue: { data in
			expectation.fulfill()
			print(data)
		}).store(in: &cancellables)
		wait(for: [expectation], timeout: 10)
	}
	
	public func testGetTenantsUsageStatistics() {
		let expectation = XCTestExpectation(description: "ok")
		var cancellables = Set<AnyCancellable>()
		try? TestableUsageStatisticsApi().getTenantsUsageStatistics().sink(receiveCompletion: { completion in
			print(completion)
		}, receiveValue: { data in
			expectation.fulfill()
			print(data)
		}).store(in: &cancellables)
		wait(for: [expectation], timeout: 10)
	}
	
	public func testGetMetadata() {
		let expectation = XCTestExpectation(description: "ok")
		var cancellables = Set<AnyCancellable>()
		try? TestableUsageStatisticsApi().getMetadata().sink(receiveCompletion: { completion in
			print(completion)
		}, receiveValue: { data in
			expectation.fulfill()
			print(data)
		}).store(in: &cancellables)
		wait(for: [expectation], timeout: 10)
	}
}
