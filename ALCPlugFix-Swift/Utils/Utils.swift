//
//  Utils.swift
//  ALCPlugFix-Swift
//
//  Created by Nick on 10/14/20.
//

import Foundation

@discardableResult
func runShellCommand(_ command: String, args: [String]) -> String? {
    #if DEBUG
    print("Running: \(command) with args: \(args)")
    #endif
    
    let task = Process()
    task.executableURL = URL(fileURLWithPath: command)
    task.arguments = args
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    
    do {
        try task.run()
    }
    catch let ex {
        return ex.localizedDescription
    }
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)
    
    #if DEBUG
    print("Output: \(output ?? "")")
    #endif
    
    task.waitUntilExit()
    
    return output?.trimmingCharacters(in: .whitespacesAndNewlines)
}
