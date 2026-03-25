/**
 * @file        KSFileInterface.swift
 * @brief      Extend FMIFileInterface class
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import MultiDataKit
import JavaScriptCore
import Foundation

@objc public protocol KSFileInterfaceProtocol: JSExport
{
        func inputFileHandle() -> JSValue
        func outputFileHandle() -> JSValue
        func errorFileHandle() -> JSValue
}

@objc public class KSFileInterface: NSObject, KSFileInterfaceProtocol
{
        private var mFileInterface:     MIFileInterface
        private var mContext:           KSContext

        public init(fileInterface intf: MIFileInterface, context ctxt: KSContext){
                mFileInterface  = intf
                mContext        = ctxt
        }

        public func inputFileHandle() -> JSValue {
                let handle = KSFileHandle(fileHandle: mFileInterface.inputFileHandle, context: mContext)
                return JSValue(object: handle, in: mContext)
        }

        public func outputFileHandle() -> JSValue {
                let handle = KSFileHandle(fileHandle: mFileInterface.outputFileHandle, context: mContext)
                return JSValue(object: handle, in: mContext)
        }

        public func errorFileHandle() -> JSValue {
                let handle = KSFileHandle(fileHandle: mFileInterface.errorFileHandle, context: mContext)
                return JSValue(object: handle, in: mContext)
        }
}
