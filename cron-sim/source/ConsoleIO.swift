//
//  ConsoleIO.swift
//  bloghelp
//
//  Created by Boris Yurkevich on 23/02/2020.
//  Copyright © 2020 Boris Yurkevich. All rights reserved.
//

import Foundation

class ConsoleIO {

    /// A helper which reads stdin
    func getInput() -> String {
      // 1
      let keyboard = FileHandle.standardInput
      // 2
      let inputData = keyboard.availableData
      // 3
      let strData = String(data: inputData, encoding: String.Encoding.utf8)!
      // 4
      return strData.trimmingCharacters(in: CharacterSet.newlines)
    }
}
