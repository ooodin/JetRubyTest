//
//  JetRubyTestTests.swift
//  JetRubyTestTests
//
//  Created by Artem Semavin on 23/07/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import XCTest
import Argo

@testable import JetRubyTest

class JetRubyTestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDecodeShotModel() {
        
        let bundle = Bundle(for: JetRubyTestTests.self)
        let path = URL(fileURLWithPath: bundle.path(forResource: "Shot", ofType: "json")!)
        
        do {
            let jsonData = try Data(contentsOf: path)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
            
            let result = Shot.decode(JSON(json))
            switch result {
            case let .success(shot):
                XCTAssertEqual(shot.id, 3675960)
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
            
        } catch let error {
            XCTFail(error.localizedDescription)
        }
        
    }
    
}
