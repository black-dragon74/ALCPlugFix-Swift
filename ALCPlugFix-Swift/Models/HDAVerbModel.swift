//
//  HDAVerbModel.swift
//  ALCPlugFix-Swift
//
//  Created by Nick on 10/14/20.
//

import Foundation

struct HDAVerbModel: Codable {
    let enabled: Bool               // Whether the command is supposed to be executed or not, overrides all conditions
    let comment: String?            // Human readable description of the command
    let nodeID: String              // Node id of the codec
    let verb: String                // Verb selector (see hdaverb.h)
    let param: String               // The command for the node
    let onBoot: Bool                // Send verb on boot (at lauchd load actually)
    let onWake: Bool                // Send verb when machine wakes from sleep
    let onSleep: Bool               // Send verb when machine goes to sleep
    let onConnect: Bool             // Send verb on headphone plug in
    let onDisconnect: Bool          // Send verb on headphone plug out

    // For easy decoding
    enum CodingKeys: String, CodingKey {
        case enabled = "Enabled"
        case comment = "Comment"
        case nodeID = "Node ID"
        case verb = "Verb"
        case param = "Param"
        case onBoot = "On Boot"
        case onWake = "On Wake"
        case onSleep = "On Sleep"
        case onConnect = "On Connect"
        case onDisconnect = "On Disconnect"
    }
}
