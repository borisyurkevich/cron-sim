import Foundation
import AppKit

struct Model {
    var minute: String
    var hour: String
    var name: String

    var h: Int? {
        Int(hour)
    }
    var m: Int? {
        Int(minute)
    }

    var frequency: Frequency {
        if let value = Frequency(rawValue: name) {
            return value
        } else {
            return .arbitrary
        }
    }

    init(minute: String = "*", hour: String = "*", name: String = "Untitled") {
        self.minute = minute
        self.hour = hour
        self.name = name
    }
}

enum Frequency: String {
    case everyDay = "/bin/run_me_daily"
    case everyHour = "/bin/run_me_hourly"
    case everyMinute = "/bin/run_me_every_minute"
    case arbitrary
}

public final class CronSim {
    
    let consoleIO = ConsoleIO()

    var mode: [String] = []

    public init() {}

    func query(userInput: String) {
        guard let fileUserInput = userInput.components(separatedBy: " ").first else {
            print("Try again")
            return
        }
        guard let timeUserInput = userInput.components(separatedBy: " ").last else {
            print("Try again")
            return
        }
        guard let input = readInput(fileUserInput: fileUserInput) else {
            print("Try again")
            return
        }
        guard let jobs = parse(input: input) else {
            print("Unable to parse")
            return
        }
        solution(jobs, currentTime: timeUserInput)
    }

    func solution(_ input: [Model], currentTime: String) {
        let time = parseTimeInput(currentTime)
        var result = ""
        for job in input {
            switch job.frequency {
            case .everyHour:
                assert(job.hour == every)
                assert(job.minute != every)

                result.append("\(time.hour):")

                result.append("\(job.minute) ")
            case .everyDay:
                assert(job.hour != every)
                assert(job.minute != every)

                result.append("\(job.hour):")

                result.append("\(job.minute) ")
            case .everyMinute:
                assert(job.hour == every)
                assert(job.minute == every)
                result.append("\(time.hour):")

                result.append("\(time.minute) ")
            case .arbitrary:
                if job.hour == every {
                    result.append("\(time.hour):")
                } else {
                    result.append("\(job.hour):")
                }

                if job.minute == every {
                    if job.hour != every {
                        if job.h! > time.hour  {
                            result.append("00 ") // Run next hour
                        } else {
                            result.append("\(job.minute) ")
                        }
                    } else {
                        result.append("\(job.minute) ")
                    }
                } else {
                    result.append("\(job.minute) ")
                }

            }

            let isToday = isInToday(currentHour: time.hour,
                                    currentMinute: time.minute,
                                    inputHour: job.h ,
                                    inputMinute: job.m)
            // Is today
            result.append(isToday ? "today " : "tomorrow ")
            // Name
            result.append("- \(job.name)")

            print(result)
            result = ""
        }
    }

    private let every = "*"

    private func parseTimeInput(_ input: String) -> (hour: Int, minute: Int) {
        let components = input.components(separatedBy: ":")
        assert(components.count == 2)
        return (Int(components.first!)!, Int(components.last!)!)
    }

    public func isInToday(currentHour: Int,
                          currentMinute: Int,
                          inputHour: Int?,
                          inputMinute: Int?) -> Bool {

        if let inputHour = inputHour, let inputMinute = inputMinute {
            if inputHour > currentHour {
                return true
            } else if inputHour == currentHour && inputMinute >= currentMinute {
                return true
            } else {
                return false
            }

        } else if let inputHour = inputHour, inputMinute == nil {
            return inputHour >= currentHour

        } else if let inputMinute = inputMinute, inputHour == nil {
            if currentHour == 24 {
                return false
            }
            if currentHour == 23 {
                return inputMinute >= currentMinute
            } else {
                return true
            }

        } else {
            return true
        }
    }

    func interactiveMode() {
        print("Enter file path for the cron jobs separated by current time, e.g. input.txt 9:42")
        var shouldQuit = false
        while !shouldQuit {
            print("Enter file name or type 'quit' to quit.")
            let input = consoleIO.getInput()
            if input == "quit" {
                shouldQuit = true
            } else {
                query(userInput: input)
            }
        }
    }

    private func parse(input: String) -> [Model]? {
        func mapToken(input: String, index: inout Int, model: inout Model) {
            switch index {
            case 0:
                model.minute = input
            case 1:
                model.hour = input
            case 2:
                model.name = input
            default:
                fatalError()
            }
        }

        var index = 0
        var result: [Model] = []
        var currentModel = Model()

        let lines = input.components(separatedBy: "\n")

        for line in lines {
            for word in line.components(separatedBy: " ") {
                mapToken(input: word, index: &index, model: &currentModel)
                index += 1
                if index == 3 {
                    result.append(currentModel)
                    currentModel = Model()
                    index = 0
                }
            }
        }

        return result
    }

    private func readInput(fileUserInput: String) -> String? {
        let currentFilePath:String = #file // This only works in Xcode

        guard let currentFileURL = URL(string: currentFilePath) else {
            return nil
        }

        let path: String = currentFileURL.deletingLastPathComponent().relativePath
        let filePath = "file://\(path)/\(fileUserInput)"

        guard let source = URL(string: filePath) else {
            return nil
        }

        do {
            let data = try Data(contentsOf: source)
            guard let text = String(data: data, encoding: .utf8) else {
                print("Unable to read the file, path: \(filePath)")
                return nil
            }
            return text

        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
