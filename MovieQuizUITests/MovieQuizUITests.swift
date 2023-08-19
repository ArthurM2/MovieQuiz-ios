import XCTest

final class MovieQuizUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testYesButton() throws {
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        firstPoster.waitForExistence(timeout: 3)
        XCTAssert(firstPoster.exists)
        
        
        app.buttons["Yes"].tap()
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        secondPoster.waitForExistence(timeout: 3)
        XCTAssert(secondPoster.exists)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertNotEqual(firstPoster, secondPoster)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton() throws {
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        
        app.buttons["Yes"].tap()
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertTrue(firstPoster.exists)
        XCTAssertTrue(secondPoster.exists)
        XCTAssertNotEqual(firstPoster, secondPoster)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testAlertPresent() throws {
        for tap in 1...10 {
            app.buttons["Yes"].tap()
        }
        
        let alert = app.alerts["AlertResult"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
    }
    
    func testAlertDismiss() throws {
        for tap in 1...10 {
            app.buttons["Yes"].tap()
        }
        
        let alert = app.alerts["AlertResult"]
        alert.buttons.firstMatch.tap()
        
        let indexLabel = app.staticTexts["Index"]
        
        sleep(3)
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
