/**
 * @file        KSConverter.swift
 * @brief      Define KSConverter class
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import MultiDataKit
import JavaScriptCore
import Foundation

public class KSConverter
{
        public static func valueToStringArray(_ src: JSValue) -> Result<Array<String>, NSError> {
                if let arr = src.toArray() {
                        var result: Array<String> = []
                        for elm in arr {
                                if let str = elm as? String {
                                        result.append(str)
                                } else {
                                        let err = MIError.parseError(message:
                                                        "Array element must have string", line: 0)
                                        return .failure(err)
                                }
                        }
                        return .success(result)
                } else {
                        let err = MIError.parseError(message: "Array is required", line: 0)
                        return .failure(err)
                }
        }

        public static func stringArrayToValue(_ src: Array<String>, in ctxt: KSContext) -> JSValue {
                var arr: Array<NSString> = []
                for elm in src {
                        arr.append(elm as NSString)
                }
                return JSValue(object: NSMutableArray(array: arr), in: ctxt)
        }
}
