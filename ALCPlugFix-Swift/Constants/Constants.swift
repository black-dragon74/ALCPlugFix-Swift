//
//  Constants.swift
//  ALCPlugFix-Swift
//
//  Created by Nick on 10/20/20.
//

import Foundation

fileprivate let hdaVerbs: [String : UInt64] = [
    // GET
    "GET_STREAM_FORMAT"             :   0x0a00,
    "GET_AMP_GAIN_MUTE"             :   0x0b00,
    "GET_PROC_COEF"                 :   0x0c00,
    "GET_COEF_INDEX"                :   0x0d00,
    "PARAMETERS"                    :   0x0f00,
    "GET_CONNECT_SEL"               :   0x0f01,
    "GET_CONNECT_LIST"              :   0x0f02,
    "GET_PROC_STATE"                :   0x0f03,
    "GET_SDI_SELECT"                :   0x0f04,
    "GET_POWER_STATE"               :   0x0f05,
    "GET_CONV"                      :   0x0f06,
    "GET_PIN_WIDGET_CONTROL"        :   0x0f07,
    "GET_UNSOLICITED_RESPONSE"      :   0x0f08,
    "GET_PIN_SENSE"                 :   0x0f09,
    "GET_BEEP_CONTROL"              :   0x0f0a,
    "GET_EAPD_BTLENABLE"            :   0x0f0c,
    "GET_DIGI_CONVERT_1"            :   0x0f0d,
    "GET_DIGI_CONVERT_2"            :   0x0f0e,
    "GET_VOLUME_KNOB_CONTROL"       :   0x0f0f,
    "GET_GPIO_DATA"                 :   0x0f15,
    "GET_GPIO_MASK"                 :   0x0f16,
    "GET_GPIO_DIRECTION"            :   0x0f17,
    "GET_GPIO_WAKE_MASK"            :   0x0f18,
    "GET_GPIO_UNSOLICITED_RSP_MASK" :   0x0f19,
    "GET_GPIO_STICKY_MASK"          :   0x0f1a,
    "GET_CONFIG_DEFAULT"            :   0x0f1c,
    "GET_SUBSYSTEM_ID"              :   0x0f20,
    
    // SET
    "SET_STREAM_FORMAT"             :   0x200,
    "SET_AMP_GAIN_MUTE"             :   0x300,
    "SET_PROC_COEF"                 :   0x400,
    "SET_COEF_INDEX"                :   0x500,
    "SET_CONNECT_SEL"               :   0x701,
    "SET_PROC_STATE"                :   0x703,
    "SET_SDI_SELECT"                :   0x704,
    "SET_POWER_STATE"               :   0x705,
    "SET_CHANNEL_STREAMID"          :   0x706,
    "SET_PIN_WIDGET_CONTROL"        :   0x707,
    "SET_UNSOLICITED_ENABLE"        :   0x708,
    "SET_PIN_SENSE"                 :   0x709,
    "SET_BEEP_CONTROL"              :   0x70a,
    "SET_EAPD_BTLENABLE"            :   0x70c,
    "SET_DIGI_CONVERT_1"            :   0x70d,
    "SET_DIGI_CONVERT_2"            :   0x70e,
    "SET_VOLUME_KNOB_CONTROL"       :   0x70f,
    "SET_GPIO_DATA"                 :   0x715,
    "SET_GPIO_MASK"                 :   0x716,
    "SET_GPIO_DIRECTION"            :   0x717,
    "SET_GPIO_WAKE_MASK"            :   0x718,
    "SET_GPIO_UNSOLICITED_RSP_MASK" :   0x719,
    "SET_GPIO_STICKY_MASK"          :   0x71a,
    "SET_CONFIG_DEFAULT_BYTES_0"    :   0x71c,
    "SET_CONFIG_DEFAULT_BYTES_1"    :   0x71d,
    "SET_CONFIG_DEFAULT_BYTES_2"    :   0x71e,
    "SET_CONFIG_DEFAULT_BYTES_3"    :   0x71f,
    "SET_CODEC_RESET"               :   0x7ff
]

func getUint64Verb(from stringCommand: String) -> UInt64 {
    return hdaVerbs[stringCommand] ?? 0
}

extension String {
    // To be used only in ALCPlugFix
    func toUInt64() -> UInt64 {
        return UInt64(self.replacingOccurrences(of: "0x", with: "")) ?? 0
    }
}
