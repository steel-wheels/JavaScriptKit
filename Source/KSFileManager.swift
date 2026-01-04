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
        public func libraryDirectory(forClass cls: AnyClass) -> URL? {
                if let resdir = resourceDirectory(forClass: cls) {
                        return resdir.appending(path: "Library")
                } else {
                        return nil
                }
        }
}

