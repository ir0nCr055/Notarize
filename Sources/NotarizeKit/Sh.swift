import Foundation
import Rainbow

public func sh(_ arguments: [String]) throws -> String {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = arguments

    let outputPipe = Pipe()
    let errorPipe = Pipe()

    task.standardOutput = outputPipe
    task.standardError = errorPipe

    task.launch()
    task.waitUntilExit()

    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
    let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

    if !errorData.isEmpty {
        let error = String(decoding: outputData, as: UTF8.self)
        print("Command failed:".red)
        print(error.red)
        print("Caused by command:")
        var command = ""
        arguments.forEach { command.append($0) }
        print(command)
        throw Errors.failure
    }

    let output = String(decoding: outputData, as: UTF8.self)

    return output
}
