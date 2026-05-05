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

        private func log(error err: NSError) {
                let msg = MIError.errorToString(error: err)
                NSLog("[Error] \(msg)")
        }
}
