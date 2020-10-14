//
//  ListenerDelegate.swift
//  ALCPlugFix-Swift
//
//  Created by Nick on 10/14/20.
//

import Foundation

protocol ListenerDelegate: class {
    func headphoneDidConnect()
    func headphoneDidDisconnect()
}
