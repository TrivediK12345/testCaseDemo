//
//  SwiftUITestDemoUITests.swift
//  SwiftUITestDemoUITests
//
//  Created by Abc on 22/07/17.
//  Copyright © 2017 Websmith Solution. All rights reserved.
//

import XCTest

class SwiftUITestDemoUITests: XCTestCase {
    
    let app = XCUIApplication()
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func waitForElementToAppear(_ element: XCUIElement, file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        
        waitForExpectations(timeout: 5) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after 5 seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: line, expected: true)
            }
        }
    }
    func testExample()
    {
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testSlider()
    {
        let slider = app.sliders["0%"]
        slider.adjust(toNormalizedSliderPosition: 0.2)
    }
    func testLoginButtonAction()
    {
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText("Abc")
        
        let passwordTextField = app.textFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("123")
        
        let loginButton = app.buttons["Login"]
        loginButton.tap()
        
        let alertView = app.alerts["Error"]
        XCTAssertEqual(alertView.title,"Error")
        
        let joeButton = app.buttons["Reorder Jamnagar"]
        let brianButton = app.buttons["Reorder Baroda"]
        joeButton.press(forDuration: 0.5, thenDragTo: brianButton)
    }
    func testService()
    {
        let convertButton = app.buttons["Convert"]
        convertButton.tap()
        
        let alertViewService = app.alerts["ServiceError"]
        XCTAssertEqual(alertViewService.title,"ServiceError")
    }
    func testDatabase()
    {
        let  dbButton = app.buttons["Next"]
        dbButton.tap()
        
        let alertDB = app.alerts["DBError"]
        XCTAssertEqual(alertDB.title,"DBError")
    }
    func testPicker()
    {
        let  dbButton = app.buttons["Next"]
        dbButton.tap()
        
        let selectedFormationLabel = app.staticTexts["5 attackers, 1 setter"]
        XCTAssertFalse(selectedFormationLabel.exists)
        
        let attackersPredicate = NSPredicate(format: "label BEGINSWITH 'Attackers Formation'")
        let attackersPicker = app.pickerWheels.element(matching: attackersPredicate)
        attackersPicker.adjust(toPickerWheelValue: "5 attackers")
        
        let settersPredicate = NSPredicate(format: "label BEGINSWITH 'Setters Formation'")
        let settersPicker = app.pickerWheels.element(matching: settersPredicate)
        settersPicker.adjust(toPickerWheelValue: "1 setter")
        
        XCTAssert(selectedFormationLabel.exists)

    }
    func testWebview()
    {
        let  dbButton = app.buttons["Next"]
        dbButton.tap()
        
        let nextButton = app.buttons["Webview"]
        nextButton.tap()
       
        let disambiguationLink = app.links["Volleyball (disambiguation)"]
        self.waitForElementToAppear(disambiguationLink)
        //waitForElementToAppear(disambiguationLink)
        XCTAssert(disambiguationLink.exists)
    }
    func testSwitch()
    {
        app.switches["1"].tap()
     //   app.switches.tap()

        let alertViewService = app.alerts["SwitchError"]
        XCTAssertEqual(alertViewService.title,"SwitchError")
        
        
    }
}
