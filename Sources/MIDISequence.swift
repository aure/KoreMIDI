//
//  MIDISequence.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import AudioToolbox.MusicPlayer

public struct MIDISequence : MutableCollection, Comparable, Hashable, RangeReplaceableCollection {

    public typealias Index = Int
    public typealias IndexDistance = Index
    public typealias Element = MIDITrack

    public typealias Timestamp = Element.Timestamp
//    func copy() -> MIDISequence {
//        return MIDISequence(import: export())
//    }

    public init() {
        _impl = MIDISequenceImpl()
//        self.path = nil
    }
    
    public init(import url: URL) {
        _impl = MIDISequenceImpl(import: url)
//        self.path = path
    }
    
    public init(import data: Data) {
        _impl = MIDISequenceImpl(import: data)
    }
    
    public var startIndex: Index {
        return _impl.startIndex
    }
    
    public var endIndex : Index {
        return _impl.endIndex
    }

    public subscript(index: Index) -> Element {
        get {
            return MIDITrack(seq: _impl, no: index)
        }
        set {
            _ensureUnique()
            let value = self[index]
        }
    }

    public func index(after i: Index) -> Index {
        return i + 1
    }

    public var startTime : Timestamp? {
        return _impl.startTime
    }

    public var endTime : Timestamp? {
        return _impl.endTime
    }

    mutating
    public func replaceSubrange<C : Collection>(_ subrange: Range<Index>, with newElements: C) where C.Iterator.Element == Element {
        _ensureUnique()
        fatalError()
    }

    public var type : MusicSequenceType {
        get {
            return _impl.type
        }
//        set {
//            MusicSequenceSetSequenceType(ref, newValue)
//        }
    }

    public static func ==(lhs: MIDISequence, rhs: MIDISequence) -> Bool {
        return lhs._impl == rhs._impl
    }
    
    public static func <(lhs: MIDISequence, rhs: MIDISequence) -> Bool {
        return lhs._impl < rhs._impl
    }
    
    public var hashValue: Int {
        return _impl.hashValue
    }
    
    public func export() -> Data {
        return _impl.export()
    }
    
    public func save(to url: URL) {
        _impl.save(to: url)
    }
    
    public var tempoTrack : MIDITrack {
//        return MIDITempoTrack(ref: self)
        fatalError()
    }
    
    private mutating func _ensureUnique() {
        if !isKnownUniquelyReferenced(&_impl) {
            _impl = _impl.copy()
        }
    }
    
    internal init(impl: MIDISequenceImpl) {
        _impl = impl
    }
    
    internal private(set) var _impl: MIDISequenceImpl
}


//struct MIDISequenceView<Event: MIDIEvent> : Sequence {
//    
//}
