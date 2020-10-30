//
//  ListenerDelegate.swift
//  ALCPlugFix-Swift
//
//  Created by Nick on 10/14/20.
//

import Foundation

protocol ListenerDelegate: class {
    // Plug/Unplug
    func headphoneDidConnect()
    func headphoneDidDisconnect()

    // Mute/Unmute
    func audioSourceDidMute()
    func audioSourceDidUnmute()
}
