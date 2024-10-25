/*
 * @file KSError.swift
 * @description Define KSError class
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import Foundation

public class KSError
{
        private static let ErrorDomain = "com.github.steel-wheels.JavaScriptKit"
        
        public enum ErrorCode: Int {
                case parseError         = 1
        }

        public static func error(errorCode ecode: ErrorCode, message msg: String) -> NSError {
                let userinfo = [NSLocalizedDescriptionKey: msg]
                return NSError(domain: ErrorDomain, code: ecode.rawValue, userInfo: userinfo)
        }
        
        public static func error(errorCode ecode: ErrorCode, message msg: String, atFile fl: String, function fstr: String) -> NSError {
                let newmsg = msg + " at " + fstr + " in " + fl
                return error(errorCode: ecode, message: newmsg)
        }
        
        public static func parseError(message msg: String) -> NSError {
                return error(errorCode: ErrorCode.parseError, message: msg)
        }
        
        public static func errorToString(error err: NSError) -> String {
                let uinfo = err.userInfo
                if let msg = uinfo[NSLocalizedDescriptionKey] as? String {
                        return msg
                } else {
                        return "{Error code=\(err.code)}"
                }
        }
}
