//
//  ALCPlugFix.swift
//  ALCPlugFix-Swift
//
//  Created by Nick on 10/14/20.
//

import Foundation
import NotificationCenter

class ALCPlugFix {
    private let listener = Listener()
    private let alcVerbPath = "/usr/local/bin/alc-verb"
    private let hdaVerbs: [HDAVerbModel]

    init(withPlistFile plist: URL) throws {
        hdaVerbs = try Command.getCommands(fromPlistFile: plist)
    }

    func start() {
        // If there are verbs to be sent on boot, now is the time
        processOnBootVerbs()

        // Declare ourselves as the delegate and listen
        listener.delegate = self
        listener.listen()

        // Register ourselves as wake observer
        NotificationCenter.default.addObserver(self, selector: #selector(handleWake(_:)), name: NSWorkspace.didWakeNotification, object: nil)
    }

    private func processOnBootVerbs() {
        print("ALCPlugFix::machineDidBoot")
        hdaVerbs.filter {
            $0.onBoot && $0.enabled
        }.forEach {
            sendHDAVerb($0)
        }
    }

    private func sendHDAVerb(_ command: HDAVerbModel) {
        // Otherwise, execute the commands
        print("Executing command labelled: \(command.comment ?? "No Description")")
        runShellCommand(alcVerbPath, args: [command.nodeID, command.verb, command.param])
    }

    // MARK: - Notification handlers

    @objc private func handleWake(_ notification: NSNotification) {
        print("ALCPlugFix::machineDidWake")
        hdaVerbs.filter {
            $0.onWake && $0.enabled
        }.forEach {
            sendHDAVerb($0)
        }
    }
}

// MARK: - Listener delegate

extension ALCPlugFix: ListenerDelegate {
    func headphoneDidConnect() {
        print("ALCPlugFix::headphoneDidConnect")
        // Only if the command is supposed to be executed on connect and is enabled
        hdaVerbs.filter {
            $0.onConnect && $0.enabled
        }.forEach {
            sendHDAVerb($0)
        }
    }

    func headphoneDidDisconnect() {
        print("ALCPlugFix::headphoneDidDisconnect")
        // Only if the command is supposed to be executed on disconnect
        hdaVerbs.filter {
            $0.onDisconnect && $0.enabled
        }.forEach {
            sendHDAVerb($0)
        }
    }
}
