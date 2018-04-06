//
//  Iterators.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import AVFoundation

public class MIDIIterator: IteratorProtocol {
    public typealias Timestamp = MIDITimestamp
    public typealias Element = MIDINote

    internal init(_ content: MIDITrack, timestamp: Timestamp? = nil) {
        self.ref = MIDIIteratorCreate(ref : content.ref)
        timestamp.map {
            self.seek(to: $0)
        }
    }

    deinit {
        DisposeMusicEventIterator(ref)
    }

    public final var current: Element? {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
//        return MIDIIteratorGetCurrent(ref: ref)
//        if let e : Element = MIDIIteratorGetCurrent(ref: _ref) {
//            if let r = _timerange, !r.contains(e.timestamp) {
//                return nil
//            }
//            return e
//        }
//        return nil
    }

    internal func remove() -> Element? {
        defer {
            MusicEventIteratorDeleteEvent(ref)
        }
        return current
    }

    public func next() -> Element? {
        defer {
            fwd()
        }
        return current
    }

    public final func seek(to timestamp: Timestamp) {
        MusicEventIteratorSeek(ref, timestamp.beats)
    }

    @inline(__always)
    fileprivate func fwd() {
        MusicEventIteratorNextEvent(ref)
    }

    @inline(__always)
    fileprivate func bwd() {
        MusicEventIteratorPreviousEvent(ref)
    }

    private let ref: MusicEventIterator


//    private let _timerange: Range<Timestamp>?
}


internal class MIDIDataIterator: IteratorProtocol {
    public typealias Timestamp = MIDITimestamp
    public typealias Element = MIDIData

    internal init(_ content: MIDITrack) {
        self.ref = MIDIIteratorCreate(ref : content.ref)
    }

    deinit {
        DisposeMusicEventIterator(ref)
    }

    final var current: Element? {
        get {
            return Element(ref: ref)
        }
        set {
            fatalError()
        }
    }

    final func remove() -> Element? {
        defer {
            MusicEventIteratorDeleteEvent(ref)
        }
        return current
    }

    final func next() -> Element? {
        defer {
            fwd()
        }
        return current
    }

    final func seek(to timestamp: Timestamp) {
        MusicEventIteratorSeek(ref, timestamp.beats)
    }

    @inline(__always)
    fileprivate func fwd() {
        MusicEventIteratorNextEvent(ref)
    }

    @inline(__always)
    fileprivate func bwd() {
        MusicEventIteratorPreviousEvent(ref)
    }

    private let ref: MusicEventIterator
}

public class MIDIRangeIterator : MIDIIterator {
    public let timerange : Range<Timestamp>

    internal init(_ content: MIDITrack, timerange: Range<Timestamp>) {
        self.timerange = timerange
        super.init(content)
        self.seek(to: timerange.lowerBound)
    }

    public override func next() -> Element? {
        return super.next().flatMap {
            guard self.timerange.contains($0.timestamp) else { return nil }
            return $0
        }
    }
}

//struct MIDIEventTrackView<Element : MIDIEvent> : Sequence {
//
//    let content: MIDITrack
//    let timerange: Range<MIDITimestamp>?
//
//    init(content: MIDITrack, timerange: Range<MIDITimestamp>? = nil) {
//        self.content = content
//        self.timerange = timerange
//    }
//
//    func makeIterator() -> AnyIterator<Element> {
//        let i = MIDIIterator(content, timerange: timerange)
//
//        return AnyIterator {
//            while let n = i.next() {
//                if let nn = n as? Element {
//                    return nn
//                }
//            }
//            return nil
//        }
//    }
//}
