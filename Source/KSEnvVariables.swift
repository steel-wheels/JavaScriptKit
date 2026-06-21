/**
 * @file        KSEnvironment.swift
 * @brief      Define KSEnvironment class
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import MultiDataKit
import JavaScriptCore
import Foundation

@objc public protocol KSEnvVariablesProtocol: JSExport
{
        func setString(_ name: JSValue, _ value: JSValue)
        func getString(_ name: JSValue) -> JSValue

        func setStrings(_ name: JSValue, _ value: JSValue)
        func getStrings(_ name: JSValue) -> JSValue

        func setNumber(_ name: JSValue, _ value: JSValue)
        func getNumber(_ name: JSValue) -> JSValue

        func setURL(_ name: JSValue, _ value: JSValue)
        func getURL(_ name: JSValue) -> JSValue

        func setTextColor(_ name: JSValue, _ value: JSValue)
        func getTextColor(_ name: JSValue) -> JSValue

        func setForegroundTextColor(_ value: JSValue)
        func getForegroundTextColor() -> JSValue

        func setBackgroundTextColor(_ value: JSValue)
        func getBackgroundTextColor() -> JSValue
}

@objc public class KSEnvVariables: NSObject, KSEnvVariablesProtocol
{
        private var mEnvVariables:      MIEnvVariables
        private var mContext:           KSContext

        static func from(value val: JSValue) -> KSEnvVariables? {
                return val.toObject() as? KSEnvVariables
        }

        public init(environment env: MIEnvVariables, context ctxt: KSContext){
                mEnvVariables   = env
                mContext        = ctxt
        }

        public func setString(_ keyval: JSValue, _ strval: JSValue) {
                switch KSConverter.valueToString(keyval) {
                case .success(let keystr):
                        switch KSConverter.valueToString(strval) {
                        case .success(let valstr):
                                mEnvVariables.set(string: valstr, forKey: keystr)
                        case .failure(let err):
                                log(error: err)
                        }
                case .failure(let err):
                        log(error: err)
                }
        }

        public func getString(_ keyval: JSValue) -> JSValue {
                switch KSConverter.valueToString(keyval) {
                case .success(let keystr):
                        if let valstr = mEnvVariables.string(forKey: keystr) {
                                return JSValue(object: valstr, in: mContext)
                        }
                case .failure(let err):
                        log(error: err)
                }
                return JSValue(nullIn: mContext)
        }

        public func setStrings(_ keyval: JSValue, _ arrval: JSValue) {
                switch KSConverter.valueToString(keyval) {
                case .success(let keystr):
                        switch KSConverter.valueToStringArray(arrval) {
                        case .success(let strs):
                                mEnvVariables.set(strings: strs, forKey: keystr)
                        case .failure(let err):
                                log(error: err)
                        }
                case .failure(let err):
                        log(error: err)
                }
        }
        
        public func getStrings(_ keyval: JSValue) -> JSValue {
                switch KSConverter.valueToString(keyval) {
                case .success(let keystr):
                        if let strs = mEnvVariables.strings(forKey: keystr) {
                                return KSConverter.stringArrayToValue(strs, in: mContext)
                        }
                case .failure(let err):
                        log(error: err)
                }
                return JSValue(nullIn: mContext)
        }

        public func setNumber(_ keyval: JSValue, _ numval: JSValue) {
                switch KSConverter.valueToString(keyval) {
                case .success(let keystr):
                        switch KSConverter.valueToNumber(numval) {
                        case .success(let num):
                                mEnvVariables.set(number: num, forKey: keystr)
                        case .failure(let err):
                                log(error: err)
                        }
                case .failure(let err):
                        log(error: err)
                }
        }

        public func getNumber(_ keyval: JSValue) -> JSValue {
                switch KSConverter.valueToString(keyval) {
                case .success(let keystr):
                        if let num = mEnvVariables.number(forKey: keystr) {
                                return JSValue(object: num, in: mContext)
                        }
                case .failure(let err):
                        log(error: err)
                }
                return JSValue(nullIn: mContext)
        }

        public func setURL(_ keyval: JSValue, _ urlval: JSValue) {
                switch KSConverter.valueToString(keyval) {
                case .success(let keystr):
                        switch KSConverter.valueToURL(urlval) {
                        case .success(let valstr):
                                mEnvVariables.set(url: valstr, forKey: keystr)
                        case .failure(let err):
                                log(error: err)
                        }
                case .failure(let err):
                        log(error: err)
                }
        }

        public func getURL(_ keyval: JSValue) -> JSValue {
                switch KSConverter.valueToString(keyval) {
                case .success(let keystr):
                        if let url = mEnvVariables.url(forKey: keystr) {
                                let newobj = KSURL(URL: url, context: mContext)
                                return JSValue(object: newobj, in: mContext)
                        }
                case .failure(let err):
                        log(error: err)
                }
                return JSValue(nullIn: mContext)
        }

        public func setTextColor(_ keyval: JSValue, _ numval: JSValue) {
                switch KSConverter.valueToString(keyval) {
                case .success(let keystr):
                        setTextColor(key: keystr, numval)
                case .failure(let err):
                        log(error: err)
                }
        }

        public func setForegroundTextColor(_ value: JSValue) {
                setTextColor(key: MIEnvVariables.ForegroundColor, value)
        }

        public func setBackgroundTextColor(_ value: JSValue) {
                setTextColor(key: MIEnvVariables.BackgroundColor, value)
        }

        private func setTextColor(key keystr: String, _ numval: JSValue) {
                switch KSConverter.valueToTextColor(numval) {
                case .success(let col):
                        mEnvVariables.set(textColor: col, forKey: keystr)
                case .failure(let err):
                        log(error: err)
                }
        }

        public func getForegroundTextColor() -> JSValue {
                return getTextColor(key: MIEnvVariables.ForegroundColor)
        }

        public func getBackgroundTextColor() -> JSValue {
                return getTextColor(key: MIEnvVariables.BackgroundColor)
        }

        public func getTextColor(_ keyval: JSValue) -> JSValue {
                switch KSConverter.valueToString(keyval) {
                case .success(let keystr):
                        return getTextColor(key: keystr)
                case .failure(let err):
                        log(error: err)
                }
                return JSValue(nullIn: mContext)
        }

        private func getTextColor(key keystr: String) -> JSValue {
                if let col = mEnvVariables.textColor(forKey: keystr) {
                        return KSConverter.textColorToValue(col, mContext)
                } else {
                        return JSValue(nullIn: mContext)
                }
        }

        private func log(error err: NSError) {
                let msg = MIError.errorToString(error: err)
                NSLog("[Error] \(msg)")
        }
}
