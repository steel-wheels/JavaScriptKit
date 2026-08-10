/**
 * @file        KSFileManager.swift
 * @brief      Extend FileManafger class
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */


import MultiDataKit
import JavaScriptCore
import Foundation

extension FileManager
{
        public func libraryDirectory(forClass cls: AnyClass) -> URL? {
                if let resdir = resourceDirectory(forClass: cls) {
                        return resdir.appending(path: "Library")
                } else {
                        return nil
                }
        }
}

@objc public protocol KSFileManagerProtocol: JSExport {
        func isExist(url: JSValue) -> JSValue
        func isExecutable(url: JSValue) -> JSValue
}

@objc public class KSFileManager: NSObject, KSFileManagerProtocol
{
        private var mContext:   KSContext

        public init(context ctxt: KSContext){
                mContext = ctxt
        }

        public func isExist(url: JSValue) -> JSValue {
                guard let path = valueToURL(val: url) else {
                        NSLog("[Error] Failed to convert to URL")
                        return JSValue(bool: false, in: mContext)
                }
                let result = FileManager.default.fileExists(atPath: path.path)
                return JSValue(bool: result, in: mContext)
        }

        public func isExecutable(url: JSValue) -> JSValue {
                guard let path = valueToURL(val: url) else {
                        NSLog("[Error] Failed to convert to URL")
                        return JSValue(bool: false, in: mContext)
                }
                let result = FileManager.default.isExecutableFile(atPath: path.path)
                return JSValue(bool: result, in: mContext)
        }

        private func valueToURL(val: JSValue) -> URL? {
                if let url = val.toObject() as? KSURL {
                        return url.core
                } else {
                        return nil
                }
        }
}

