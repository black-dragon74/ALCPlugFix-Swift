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
    private let hdaVerbs: [HDAVerbModel]
    private var io_service: io_service_t = 0

    init(withPlistFile plist: URL) throws {
        hdaVerbs = try Command.getCommands(fromPlistFile: plist)
    }

    func start(_ provider: String = "ALCUserClientProvider") {
        // Connect to provider
        io_service = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching(provider))
        guard io_service != 0 else {
            print("Provider \(provider) not available!")
            exit(1)
        }

        // Declare ourselves as the delegate and listen
        listener.delegate = self
        listener.listen()

        // If there are verbs to be sent on boot, now is the time
        processOnBootVerbs()

        // Register ourselves as sleep and wake observer
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(handleSleep(_:)), name: NSWorkspace.willSleepNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(handleWake(_:)), name: NSWorkspace.didWakeNotification, object: nil)
    }

    private func processOnBootVerbs() {
        print("ALCPlugFix::machineDidBoot")
        listener.mutePropertyListenerBlock(inNumberAddresses: 0, inAddresses: &listener.muteAddress)
        hdaVerbs.filter {
            $0.onBoot && $0.enabled
        }.forEach {
            sendHDAVerb($0)
        }
    }

    private func sendHDAVerb(_ command: HDAVerbModel) {
        print("Executing command labelled: \(command.comment ?? "No Description")")

        var connect: io_connect_t = 0
        guard kIOReturnSuccess == IOServiceOpen(io_service, mach_task_self_, 0, &connect),
              connect != 0 else {
            print("Failed to connect to ALCUserClientProvider")
            exit(1)
        }

        var input: [UInt64] = [
            command.nodeID.toUInt64(),
            getUint64Verb(from: command.verb),
            command.param.toUInt64()
        ]

        var outputCount: UInt32 = 1
        var output: UInt64 = 0

        if kIOReturnSuccess != IOConnectCallScalarMethod(connect, 0, &input, 3, &output, &outputCount) {
            print("Failed to execute HDA verb\n")
        } else {
            print("Output: \(output)\n")
        }
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

    @objc private func handleSleep(_ notification: NSNotification) {
        print("ALCPlugFix::machineWillSleep")

        hdaVerbs.filter {
            $0.onSleep && $0.enabled
        }.forEach {
            sendHDAVerb($0)
        }
    }
}

// MARK: - Listener delegate

extension ALCPlugFix: ListenerDelegate {
    func headphoneDidConnect() {
        print("ALCPlugFix::headphoneDidConnect")

        hdaVerbs.filter {
            $0.onConnect && $0.enabled
        }.forEach {
            sendHDAVerb($0)
        }
    }

    func headphoneDidDisconnect() {
        print("ALCPlugFix::headphoneDidDisconnect")

        hdaVerbs.filter {
            $0.onDisconnect && $0.enabled
        }.forEach {
            sendHDAVerb($0)
        }
    }

    func audioSourceDidMute() {
        print("ALCPlugFix::audioSourceDidMute")

        hdaVerbs.filter {
            $0.onMute && $0.enabled
        }.forEach {
            sendHDAVerb($0)
        }
    }

    func audioSourceDidUnmute() {
        print("ALCPlugFix::audioSourceDidUnmute")

        hdaVerbs.filter {
            $0.onUnmute && $0.enabled
        }.forEach {
            sendHDAVerb($0)
        }
    }
}
