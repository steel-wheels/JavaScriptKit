/**
 * @file        KSURL.swift
 * @brief      Define KSURL class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiDataKit
import JavaScriptCore
import Foundation

@objc public protocol KSURLProtocol: JSExport
{
        var path: JSValue { get }
}

@objc public class KSURL: NSObject, KSURLProtocol
{
        private var mURL:       URL
        private var mContext:   KSContext

        static public func allocate(_ val: JSValue, context ctxt: KSContext) -> JSValue{
                guard let path = val.toString() else {
                        NSLog("[Error] Invalid parameter: val at \(#file)")
                        return JSValue(nullIn: ctxt)
                }
                let core = URL(filePath: path)
                let obj  = KSURL(URL: core, context: ctxt)
                return JSValue(object: obj, in: ctxt)
        }

        static public func from(value val: JSValue) -> KSURL? {
                return val.toObject() as? KSURL
        }

        public init(URL url: URL, context ctxt: KSContext){
                mURL            = url
                mContext        = ctxt
        }

        public var core: URL { get {
                return mURL
        }}

        public var path: JSValue { get {
                let str = mURL.path(percentEncoded: true)
                return JSValue(object: str, in: mContext)
        }}
}

