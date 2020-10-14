//
//  Command.swift
//  ALCPlugFix-Swift
//
//  Created by Nick on 10/14/20.
//

import Foundation

class Command {
    static func getCommands(fromPlistFile plist: URL) throws -> [HDAVerbModel] {
        let data = try Data(contentsOf: plist)
        let decoder = PropertyListDecoder()
        return try decoder.decode([HDAVerbModel].self, from: data)
    }
}
