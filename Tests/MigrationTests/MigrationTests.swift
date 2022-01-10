import XCTest
@testable import Migration

final class MigrationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Migration.reset()
    }
    
    func testMigrationReset() {
        
        let expectingBlock1Run = expectation(description: "Expecting block to be run for version 0.9")
        Migration.migrateToVersion("0.9") {
            expectingBlock1Run.fulfill()
        }
        
        let expectingBlock2Run = expectation(description: "Expecting block to be run for version 1.0")
        Migration.migrateToVersion("1.0") {
            expectingBlock2Run.fulfill()
        }
        
        Migration.reset()
        
        let expectingBlock3Run = expectation(description: "Expecting block to be run AGAIN for version 0.9")
        Migration.migrateToVersion("0.9") {
            expectingBlock3Run.fulfill()
        }
        
        let expectingBlock4Run = expectation(description: "Expecting block to be run AGAIN for version 1.0")
        Migration.migrateToVersion("1.0") {
            expectingBlock4Run.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testMigratesOnFirstRun() {
        let expectingBlockRun = expectation(description: "Should execute migration after reset")
        Migration.migrateToVersion("1.0") {
            expectingBlockRun.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    func testMigratesOnce() {
        let expectingBlockRun = expectation(description: "Expecting block to be run")
        Migration.migrateToVersion("1.0") {
            expectingBlockRun.fulfill()
        }
        Migration.migrateToVersion("1.0") {
            XCTFail("Should not execute a block for the same version twice")
        }
        waitForExpectations(timeout: 1)
    }
    
    func testMigratesInNaturalSortOrder()
    {
        let expectingBlock1Run = expectation(description: "Expecting block to be run for version 0.9")
        Migration.migrateToVersion("0.9") {
            expectingBlock1Run.fulfill()
        }
        
        Migration.migrateToVersion("0.1") {
            XCTFail("Should use natural sort order, e.g. treat 0.10 as a follower of 0.9")
        }
        
        let expectingBlock2Run = expectation(description: "Expecting block to be run for version 0.10")
        Migration.migrateToVersion("0.10") {
            expectingBlock2Run.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
}
