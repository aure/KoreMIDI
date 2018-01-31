//
//  MIDIMetaTimeSignatureEvent.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 1/31/18.
//

import AudioToolbox.MusicPlayer
import Foundation



extension AudioToolbox.MIDIMetaEvent {

//    var data: Data {
//
//        return Data(bytesNoCopy: <#T##UnsafeMutableRawPointer#>, count: <#T##Int#>, deallocator: <#T##Data.Deallocator#>)
//    }

    init(type: UInt8, data: Data) {
        let header = MemoryLayout<AudioToolbox.MIDIMetaEvent>.size - MemoryLayout<UInt8>.size
        let alloc = header + data.count

        var data = Data(capacity: alloc)
//        self.init(metaEventType: type,
//                  unused1: 0, unused2: 0, unused3: 0,
//                  dataLength: 0, data: 0)
        fatalError()

    }
}

///
/// this is for retrieving, not for
///

internal protocol StaticSizeMessage {
    static var staticSize: Int { get }
}
internal protocol DynamicSizeMessage : StaticSizeMessage {
    var dynamicSize: Int { get }
}

extension DynamicSizeMessage {
    var totalSize : Int {
        return Self.staticSize + dynamicSize
    }
}

extension AudioToolbox.MIDIMetaEvent: DynamicSizeMessage {
    static var staticSize: Int {
        return MemoryLayout<AudioToolbox.MIDIMetaEvent>.size - MemoryLayout<UInt8>.size
    }

    var dynamicSize: Int {
        return Int(dataLength)
    }
}

internal protocol MIDIMetaEventType {
    var size: Int { get }
}

extension Data {
    init<M: DynamicSizeMessage>(message: UnsafePointer<M>) {
        self.init(bytes: message, count: message.pointee.dynamicSize)
    }
}

internal struct MIDIMetaEvent2<M: DynamicSizeMessage> {

    /// I hate this structure a lot, it's impossible to do cleanly.
    enum Subtype: UInt8 {
        case sequenceNumber = 0x00,
        textEvent = 0x01,
        copyrightNotice = 0x02,
        trackSequenceName = 0x03,
        instrumentName  = 0x04,
        lyricText = 0x05,
        markerText              = 0x06,
        cuePoint                = 0x07,
        MIDIChannelPrefix       = 0x20,
        endOfTrack              = 0x2F,
        tempoSetting            = 0x51,
        SMPTEOffset             = 0x54,
        timeSignature           = 0x58,
        keySignature            = 0x59,
        sequencerSpecificEvent  = 0x7F,
        invalid                    = 0x66
    }

//    var metaEventType: Subtype {
//        get {
//            return Subtype(rawValue: ptr.pointee.metaEventType)!
//        }
//        set {
//            ptr.pointee.metaEventType = newValue.rawValue
//        }
//    }

    private var data: Data
//    private let ptr: UnsafeMutablePointer<>

    init(type: Subtype, message: inout M) {
        self.data = Data(message: &message)
//        let header = AudioToolbox.MIDIMetaEvent.headerSize
//        let alloc = header + data.count
//        self.data = Data(

        fatalError()
//        ptr = self.data.withUnsafeMutableBytes { $0 }
    }

    func insert(to: MIDIMetaTrack) {

    }
}
struct MIDIMetaTimeSignatureEvent {

}