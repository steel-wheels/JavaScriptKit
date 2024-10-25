/*
 * @file KSStringStream.swift
 * @description Define KSStringStream class
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import Foundation

public protocol KSInputStream
{
        func getc() -> Character?
        func ungetc() -> Character?
}

public class KSStringStream: KSInputStream
{
        private var mString:    String
        private var mIndex:     String.Index
        
        public init(string str: String){
                mString = str
                mIndex  = str.startIndex
        }
        
        public func getc() -> Character? {
                if mIndex < mString.endIndex {
                        let c = mString[mIndex]
                        mIndex = mString.index(after: mIndex)
                        return c
                } else {
                        return nil
                }
        }
        
        public func ungetc() -> Character? {
                if mString.startIndex < mIndex {
                        mIndex = mString.index(before: mIndex)
                        return mString[mIndex]
                } else {
                        return nil
                }
        }
}

