//
//  parser_tests.swift
//  parser-tests
//
//  Created by Boris Yurkevich on 09/09/2022.
//  Copyright © 2022 Boris Yurkevich. All rights reserved.
//

import XCTest
@testable import cron_sim

class parser_tests: XCTestCase {

    let cronSim = CronSim()

    func testToday() {

        let runDaily = cronSim.isInToday(currentHour: 16,
                                         currentMinute: 10,
                                         inputHour: 1,
                                         inputMinute: 30)
        XCTAssertFalse(runDaily)

        let runHourly = cronSim.isInToday(currentHour: 16,
                                          currentMinute: 10,
                                          inputHour: nil,
                                          inputMinute: 45)
        XCTAssert(runHourly)

        let runMinutly = cronSim.isInToday(currentHour: 16,
                                           currentMinute: 10,
                                           inputHour: nil,
                                           inputMinute: nil)
        XCTAssert(runMinutly)

        let runArbitrary = cronSim.isInToday(currentHour: 16,
                                             currentMinute: 10,
                                             inputHour: 19,
                                             inputMinute: nil)
        XCTAssert(runArbitrary)
    }

    func testDaily() {
        let runDaily = cronSim.isInToday(currentHour: 16,
                                         currentMinute: 10,
                                         inputHour: 16,
                                         inputMinute: 10)
        XCTAssert(runDaily)

        let runDaily2 = cronSim.isInToday(currentHour: 16,
                                          currentMinute: 10,
                                          inputHour: 16,
                                          inputMinute: 11)
        XCTAssert(runDaily2)

        let runDaily3 = cronSim.isInToday(currentHour: 16,
                                          currentMinute: 10,
                                          inputHour: 17,
                                          inputMinute: 10)
        XCTAssert(runDaily3)

        let runDaily4 = cronSim.isInToday(currentHour: 16,
                                          currentMinute: 10,
                                          inputHour: 16,
                                          inputMinute: 9)
        XCTAssertFalse(runDaily4)

        let runDaily5 = cronSim.isInToday(currentHour: 16,
                                          currentMinute: 10,
                                          inputHour: 15,
                                          inputMinute: 11)
        XCTAssertFalse(runDaily5)

        let runDaily6 = cronSim.isInToday(currentHour: 15,
                                          currentMinute: 09,
                                          inputHour: 15,
                                          inputMinute: 11)
        XCTAssert(runDaily6)
    }

    func testHourly() {
        let runHourly1 = cronSim.isInToday(currentHour: 23,
                                           currentMinute: 00,
                                           inputHour: nil,
                                           inputMinute: 01)
        XCTAssert(runHourly1)

        let runHourly2 = cronSim.isInToday(currentHour: 23,
                                           currentMinute: 01,
                                           inputHour: nil,
                                           inputMinute: 01)
        XCTAssert(runHourly2)

        let runHourly3 = cronSim.isInToday(currentHour: 23,
                                           currentMinute: 01,
                                           inputHour: nil,
                                           inputMinute: 02)
        XCTAssert(runHourly3)

        let runHourly4 = cronSim.isInToday(currentHour: 23,
                                           currentMinute: 03,
                                           inputHour: nil,
                                           inputMinute: 02)
        XCTAssertFalse(runHourly4)
    }

    func testArbitrary() {
        let runArbitrary = cronSim.isInToday(currentHour: 16,
                                             currentMinute: 10,
                                             inputHour: nil,
                                             inputMinute: 09)
        XCTAssert(runArbitrary)

        let runArbitrary2 = cronSim.isInToday(currentHour: 13,
                                              currentMinute: 00,
                                              inputHour: 12,
                                              inputMinute: nil)
        XCTAssertFalse(runArbitrary2)

        let runArbitrary3 = cronSim.isInToday(currentHour: 11,
                                              currentMinute: 00,
                                              inputHour: 12,
                                              inputMinute: nil)
        XCTAssert(runArbitrary3)

        let runArbitrary4 = cronSim.isInToday(currentHour: 12,
                                              currentMinute: 00,
                                              inputHour: 12,
                                              inputMinute: nil)
        XCTAssert(runArbitrary4)

        let runArbitrary5 = cronSim.isInToday(currentHour: 24,
                                              currentMinute: 00,
                                              inputHour: nil,
                                              inputMinute: 30)
        XCTAssertFalse(runArbitrary5)
    }
}
