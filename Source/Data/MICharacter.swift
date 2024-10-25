/*
 * @file KSCharacter.swift
 * @description Extend Character class
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import Foundation

public extension Character
{
        static let newline: Character           = "\n"
        static let singleQuotation: Character   = "`"
        static let quotation: Character         = "\""
        static let backslash: Character         = "\\"
        static let tab: Character               = "\t"
        static let null: Character              = "\0"
        static let carriageReturn: Character    = "\r"
        
        var isFirstIdentifier: Bool { get {
                return self.isLetter || (self == "_")
        }}
        
        var isMiddleIdentifier: Bool { get {
                return self.isLetter || (self == "_") || self.isNumber
        }}
}

