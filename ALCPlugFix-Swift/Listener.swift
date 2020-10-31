//
//  Listener.swift
//  ALCPlugFix-Swift
//
//  Created by Nick on 10/14/20.
//  Adapted from ALCPlugFix (main.m)
//

import CoreAudio
import Foundation

class Listener {
    private var defaultDevice: AudioDeviceID = 0
    private var dataSourceID: UInt32 = 0
    private var isMuted: UInt32 = 0

    private var defaultSize = UInt32(MemoryLayout<AudioDeviceID>.size)
    private var dataSourceSize = UInt32(MemoryLayout<UInt32>.size)

    private var defaultAddress = AudioObjectPropertyAddress(
        mSelector: kAudioHardwarePropertyDefaultOutputDevice,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMaster
    )
    private var sourceProperty = AudioObjectPropertyAddress(
        mSelector: kAudioDevicePropertyDataSource,
        mScope: kAudioDevicePropertyScopeOutput,
        mElement: kAudioObjectPropertyElementMaster
    )
    var muteAddress = AudioObjectPropertyAddress(
        mSelector: kAudioDevicePropertyMute,
        mScope: kAudioDevicePropertyScopeOutput,
        mElement: kAudioObjectPropertyElementMaster
    )

    var delegate: ListenerDelegate?

    init() {
        AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &defaultAddress, 0, nil, &defaultSize, &defaultDevice)
    }

    func listen() {
        AudioObjectAddPropertyListenerBlock(defaultDevice, &sourceProperty, .main, outputPropertyListenerBlock)
        AudioObjectAddPropertyListenerBlock(defaultDevice, &muteAddress, .main, mutePropertyListenerBlock)
    }

    // MARK: - Listeners as per CoreAudio:136

    func outputPropertyListenerBlock(inNumberAddresses: UInt32, inAddresses: UnsafePointer<AudioObjectPropertyAddress>) {
        AudioObjectGetPropertyData(defaultDevice, inAddresses, 0, nil, &dataSourceSize, &dataSourceID)

        // 1751412846 is for Headphones
        // 1769173099 is for speakers
        // print(dataSourceID)
        if dataSourceID == 1751412846 {
            delegate?.headphoneDidConnect()
        }

        if dataSourceID == 1769173099 {
            delegate?.headphoneDidDisconnect()
        }
    }

    func mutePropertyListenerBlock(inNumberAddresses: UInt32, inAddresses: UnsafePointer<AudioObjectPropertyAddress>) {
        //TODO:- For some reason the listener block is called twice, fix it later
        // Get the mute/unmute status and call the delegate methods
        AudioObjectGetPropertyData(defaultDevice, inAddresses, 0, nil, &dataSourceSize, &isMuted)

        if isMuted != 1 {
            delegate?.audioSourceDidUnmute()
        }
        else {
            delegate?.audioSourceDidMute()
        }
    }
}
