//
//  MockApiTests.swift
//  RestApiAppTests
//
//  Created by Nele Müller on 12.06.18.
//  Copyright © 2018 Nele Müller. All rights reserved.
//

import XCTest
@testable import RestApiApp

class MockApiTests: XCTestCase {
    
    var sut: SpeciesViewController!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        self.window = UIWindow()
        setupSpeciesViewController()
    }
    
    override func tearDown() {
        self.window = nil
        super.tearDown()
    }
    
    func testMockApiCall() {
        let networking = MockNetworking()
        let networkManager = NetworkManager(networking: networking)
        self.sut.changeNetworkManager(to: networkManager)
        self.sut.viewDidLoad()
        
        self.loadView()
        let speciesWrapper = self.sut.speciesWrapper
        
        XCTAssertNotNil(speciesWrapper)
        XCTAssertEqual(speciesWrapper?.count, 37)
        XCTAssertEqual(speciesWrapper?.species?.count, 10)
    }
}

extension MockApiTests {
    func setupSpeciesViewController() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        self.sut = storyboard.instantiateInitialViewController() as? SpeciesViewController
    }
    
    func loadView() {
        self.window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
}
