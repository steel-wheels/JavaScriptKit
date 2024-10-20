/*
 * @file KSValue.swift
 * @description Define KSValue data structure
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import Foundation

public enum KSValueType: Int {
        case int
        case float
        case string
}

public enum KSValueBody {
        case int(Int)
        case float(Double)
        case string(String)
}

public struct KSValue {
        public var      type:  KSValueType
        public var      value: KSValueBody
        public init(type: KSValueType, value: KSValueBody) {
                self.type = type
                self.value = value
        }
}
