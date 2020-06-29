import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(UBottomSheetTests.allTests),
    ]
}
#endif
