//
//  MIDIEventType
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/8/17.
//
//

import AudioToolbox.MusicPlayer

public protocol MIDIEventConvertible : Hashable {

}

internal protocol MIDITrackEvent {
    associatedtype Timestamp = Double
    func insert(to ref: MIDITrack, at timestamp: Timestamp)
}

extension ExtendedNoteOnEvent : Hashable, CustomStringConvertible, MIDIEventConvertible, MIDITrackEvent {
    public static func ==(lhs: ExtendedNoteOnEvent, rhs: ExtendedNoteOnEvent) -> Bool {
        return lhs.instrumentID == rhs.instrumentID &&
            lhs.groupID == rhs.groupID &&
            lhs.duration == rhs.duration
    }

    internal func insert(to ref: MIDITrack, at timestamp: Double) {
        withCopy(of: self) {
            MusicTrackNewExtendedNoteEvent(ref.ref, timestamp, $0)
        }
    }

    public var description: String {
        return ""
    }

    public var hashValue: Int {
        return groupID.hashValue
    }
}

///
/// MARK: ExtendedTempoEvent
///

extension ExtendedTempoEvent : Hashable, CustomStringConvertible {
    public var hashValue: Int {
        return bpm.hashValue
    }

    public static func ==(lhs: ExtendedTempoEvent, rhs: ExtendedTempoEvent) -> Bool {
        return lhs.bpm == rhs.bpm
    }

    public var description: String {
        return ""
    }

    public func insert(to ref: MusicTrack, at timestamp: Double) {
        MusicTrackNewExtendedTempoEvent(ref, timestamp, bpm)
    }
}


///
/// MARK: MusicEventUserData
///

extension MusicEventUserData : Hashable, CustomStringConvertible {
    public var hashValue: Int {
        return length.hashValue
    }

    static public func ==(lhs: MusicEventUserData, rhs: MusicEventUserData) -> Bool {
        return lhs.length == rhs.length && lhs.data == rhs.data
    }

    public var description: String {
        return ""
    }

    internal func insert(to ref: MIDITrack, at timestamp: Double) {
        withCopy(of: self) {
            MusicTrackNewUserEvent(ref.ref, timestamp, $0)
        }
    }
}

///
/// MARK: MIDIMetaEvent
///

extension MIDIMetaEvent : Hashable, CustomStringConvertible, MIDIEventConvertible, MIDITrackEvent {

    public var hashValue: Int {
        return metaEventType.hashValue
    }

    public static func ==(lhs: MIDIMetaEvent, rhs: MIDIMetaEvent) -> Bool {
        return lhs.metaEventType == rhs.metaEventType &&
            lhs.dataLength == rhs.dataLength &&
            lhs.data == rhs.data
    }

    public static func <(lhs: MIDIMetaEvent, rhs: MIDIMetaEvent) -> Bool {
        return lhs.metaEventType < rhs.metaEventType
    }

    public var description: String {
        return ""
    }

    internal func insert(to ref: MIDITrack, at timestamp: Double) {
        withCopy(of: self) {
            MusicTrackNewMetaEvent(ref.ref, timestamp, $0)
        }
    }
}

//extension MIDINoteMessage : MIDIEventConvertible, MIDITrackEvent  {}
///
/// MARK: MIDINoteMessage
///
extension MIDINoteMessage : Hashable, CustomStringConvertible, MIDIEventConvertible, MIDITrackEvent {

    init(note: UInt8, duration: Float32) {
        self.init(channel: 0, note: note, velocity: 100, releaseVelocity: 0, duration: duration)
    }

    public var description : String {
        return "note: \(note), duration: \(duration)"
    }

    public static func ==(lhs: MIDINoteMessage, rhs: MIDINoteMessage) -> Bool {
        return lhs.duration == rhs.duration &&
            lhs.note == rhs.note &&
            lhs.channel == rhs.channel &&
            lhs.velocity == rhs.velocity &&
            lhs.releaseVelocity == rhs.releaseVelocity
    }

    internal func insert(to ref: MIDITrack, at timestamp: Double) {
        withCopy(of: self) {
            MusicTrackNewMIDINoteEvent(ref.ref, timestamp, $0)
        }
    }

    public var hashValue: Int {
        return channel.hashValue ^ note.hashValue
    }
}

///
/// MARK: MIDIChannelMessage
///

extension MIDIChannelMessage : Hashable, CustomStringConvertible, MIDIEventConvertible, MIDITrackEvent {
    public static func ==(lhs: MIDIChannelMessage, rhs: MIDIChannelMessage) -> Bool {
        return lhs.status == rhs.status && lhs.data1 == rhs.data1 && lhs.data2 == rhs.data2
    }

    public var hashValue: Int {
        return status.hashValue
    }

    public var description: String {
        return "cc: \(status): [\(data1), \(data2)]"
    }

    internal func insert(to ref: MIDITrack, at timestamp: Double) {
        withCopy(of: self) {
            MusicTrackNewMIDIChannelEvent(ref.ref, timestamp, $0)
        }
    }
}

///
/// MARK: MIDIRawData
///

extension MIDIRawData : Hashable, CustomStringConvertible, MIDIEventConvertible, MIDITrackEvent {
    public static func ==(lhs: MIDIRawData, rhs: MIDIRawData) -> Bool {
        return lhs.length == rhs.length && lhs.data == rhs.data
    }

    public var hashValue: Int {
        return length.hashValue
    }

    public var description: String {
        return ""
    }

    internal func insert(to ref: MIDITrack, at timestamp: Double) {
        withCopy(of: self) {
            MusicTrackNewMIDIRawDataEvent(ref.ref, timestamp, $0)
        }
    }
}

///
/// MARK: ParameterEvent
///

extension ParameterEvent : Hashable, CustomStringConvertible, MIDIEventConvertible, MIDITrackEvent {
    public static func ==(lhs: ParameterEvent, rhs: ParameterEvent) -> Bool {
        return lhs.parameterID == rhs.parameterID &&
            lhs.scope == rhs.scope &&
            lhs.element == rhs.element &&
            lhs.value == rhs.value
    }

//    public static func <(lhs: ParameterEvent, rhs: ParameterEvent) -> Bool {
//        return lhs.scope < rhs.scope && lhs.parameterID < rhs.parameterID
//    }
    public var hashValue: Int {
        return scope.hashValue
    }

    public var description: String {
        return ""
    }

    internal func insert(to ref: MIDITrack, at timestamp: Double) {
        withCopy(of: self) {
            MusicTrackNewParameterEvent(ref.ref, timestamp, $0)
        }
    }
}

///
/// MARK: AUPresetEvent
///

extension AUPresetEvent : Hashable, CustomStringConvertible, MIDIEventConvertible, MIDITrackEvent {
    static public func ==(lhs: AUPresetEvent, rhs: AUPresetEvent) -> Bool {
        return lhs.scope == rhs.scope &&
            lhs.element == rhs.element &&
            lhs.preset.toOpaque() == rhs.preset.toOpaque()
    }

//    static public func <(lhs: AUPresetEvent, rhs: AUPresetEvent) -> Bool {
//        return lhs.scope < rhs.scope
//    }
    public var hashValue: Int {
        return scope.hashValue
    }

    public var description: String {
        return ""
    }

    internal func insert(to ref: MIDITrack, at timestamp: Double) {
        withCopy(of: self) {
            MusicTrackNewAUPresetEvent(ref.ref, timestamp, $0)
        }
    }

}

extension ExtendedControlEvent : Hashable, CustomStringConvertible, MIDIEventConvertible, MIDITrackEvent {
    static public func ==(lhs: ExtendedControlEvent, rhs: ExtendedControlEvent) -> Bool {
        //        return lhs.scope == rhs.scope &&
        //            lhs.element == rhs.element &&
        //            lhs.preset.toOpaque() == rhs.preset.toOpaque()
        fatalError()
    }

//    static public func <(lhs: ExtendedControlEvent, rhs: ExtendedControlEvent) -> Bool {
//        //        return lhs.scope < rhs.scope
//        fatalError()
//    }
    public var hashValue: Int {
        //        return scope.hashValue
        fatalError()
    }
    
    public var description: String {
        return ""
    }

    internal func insert(to ref: MIDITrack, at timestamp: Double) {
        var cpy = self
        fatalError()
        //        _ = withUnsafePointer(to: &cpy) {
        //            MusicTrackNewExtendedNoteEvent(ref, at, $0)
        //        }
    }


}

