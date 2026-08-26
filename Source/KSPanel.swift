/**
 * @file        KSPanel.swift
 * @brief      Define KSPanel class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiDataKit
import MultiUIKit
import JavaScriptCore
import Foundation

#if os(OSX)

@objc public protocol KSOpenPanelProtocol: JSExport
{
        var selected:    JSValue { get }
        var selectedURL: JSValue { get }
        func show(_ title: JSValue, _ ftype: JSValue, _ extensions: JSValue) -> JSValue
}

@objc public protocol KSSavePanelProtocol: JSExport
{
        var selected:    JSValue { get }
        var selectedURL: JSValue { get }
        func show(_ title: JSValue, _ outdir: JSValue) -> JSValue
}

@objc class KSOpenPanel: NSObject, KSOpenPanelProtocol
{
        private var mOpenPanel:         MIOpenPanel
        private var mContext:           KSContext

        static public func allocate(context ctxt: KSContext) -> JSValue{
                let obj = KSOpenPanel(context: ctxt)
                return JSValue(object: obj, in: ctxt)
        }

        public init(context ctxt: KSContext){
                mOpenPanel      = MIOpenPanel()
                mContext        = ctxt
        }

        public var selected: JSValue { get {
                return JSValue(bool: mOpenPanel.selected, in: mContext)
        }}

        public var selectedURL: JSValue { get {
                if let url = mOpenPanel.selectedURL {
                        let obj = KSURL(URL: url, context: mContext)
                        return JSValue(object: obj, in: mContext)
                } else {
                        return JSValue(nullIn: mContext)
                }
        }}

        public func show(_ titleval: JSValue, _ ftypeval: JSValue, _ extvals: JSValue) -> JSValue {
                var result: Bool = false
                switch KSConverter.valueToString(titleval) {
                case .success(let title):
                        switch KSConverter.valueToInt32(ftypeval) {
                        case .success(let ftypenum):
                                switch KSConverter.valueToStringArray(extvals) {
                                case .success(let exts):
                                        let ftype: MIOpenPanel.FileType
                                        ftype = ftypenum == 0 ? .file : .directory
                                        mOpenPanel.show(title: title, type: ftype, fileExtensions: exts)
                                        result = true
                                case .failure(_):
                                        break
                                }
                        case .failure(_):
                                break
                        }
                case .failure(_):
                        break
                }
                return JSValue(bool: result, in: mContext)
        }
}

@objc class KSSavePanel: NSObject, KSSavePanelProtocol
{
        private var mSavePanel:         MISavePanel
        private var mContext:           KSContext

        static public func allocate(context ctxt: KSContext) -> JSValue{
                let obj = KSSavePanel(context: ctxt)
                return JSValue(object: obj, in: ctxt)
        }

        public init(context ctxt: KSContext){
                mSavePanel      = MISavePanel()
                mContext        = ctxt
        }

        public var selected: JSValue { get {
                return JSValue(bool: mSavePanel.selected, in: mContext)
        }}

        public var selectedURL: JSValue { get {
                if let url = mSavePanel.selectedURL {
                        let obj = KSURL(URL: url, context: mContext)
                        return JSValue(object: obj, in: mContext)
                } else {
                        return JSValue(nullIn: mContext)
                }
        }}

        public func show(_ titleval: JSValue, _ outdirval: JSValue) -> JSValue {
                var result = false
                switch KSConverter.valueToString(titleval) {
                case .success(let title):
                        switch KSConverter.valueToURL(outdirval) {
                        case .success(let outdir):
                                mSavePanel.show(title: title, outputDirectory: outdir)
                                result = true
                        case .failure(_):
                                break
                        }
                case .failure(_):
                        break
                }
                return JSValue(bool: result, in: mContext)
        }
}

#endif // os(OSX)
