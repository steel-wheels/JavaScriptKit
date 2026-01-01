/**
 * @file        KSFileManager.swift
 * @brief      Extend FileManafger class
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */


import MultiDataKit
import Foundation

extension FileManager
{
        public var libraryDirectory: URL? { get {
                if let resdir = resourceDirectory(forClass: KSContext.self) {
                        return resdir.appending(path: "Library")
                } else {
                        return nil
                }
        }}
}

