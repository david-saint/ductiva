import XCTest
import SwiftData
@testable import ductiva

final class SharedDataTests: XCTestCase {
    
    func testMakeModelContainerUsesAppGroup() throws {
        // Skip this test on CI/Linux if it causes issues, 
        // but let's try to verify the URL points to the app group
        
        let container = try SharedContainer.make()
        
        // ModelContainer configuration url should be in the shared App Group directory
        if let config = container.configurations.first {
            let url = config.url
            XCTAssertTrue(url.path.contains("group.com.saint.ductiva"), "The database URL should be inside the App Group container")
            XCTAssertEqual(url.lastPathComponent, "ductiva.sqlite", "The database file should be named ductiva.sqlite")
        } else {
            XCTFail("Could not find the configuration URL")
        }
    }
}