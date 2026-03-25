/**
 * @file        KSFileHandle.swift
 * @brief      Extend FileHandle class
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import MultiDataKit
import JavaScriptCore
import Foundation

@objc public protocol KSFileHandleProtocol: JSExport
{
        func setReader(_ calllback: JSValue)
        func write(_ str: JSValue)
}

@objc public class KSFileHandle: NSObject, KSFileHandleProtocol
{
        private var mFileHandle:        FileHandle
        private var mContext:           KSContext

        public init(fileHandle hdl: FileHandle, context ctxt: KSContext){
                mFileHandle     = hdl
                mContext        = ctxt
        }

        public func setReader(_ calllback: JSValue) {
                mFileHandle.setReader(reader: {
                        @Sendable (_ str: String) -> Void in
                        if let val = JSValue(object: str, in: self.mContext) {
                                val.call(withArguments: [val])
                        } else {
                                NSLog("[Error] Failed to allocate value at \(#file)")
                        }
                })
        }

        public func write(_ strval: JSValue) {
                if let str = strval.toString() {
                        mFileHandle.write(string: str)
                } else {
                        NSLog("[Error] Failed to write \(strval) at \(#file)")
                }
        }
}

