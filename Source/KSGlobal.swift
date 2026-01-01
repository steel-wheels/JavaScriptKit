/**
 * @file        KSGlobalswift
 * @brief      Define KSGlobal class
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import JavaScriptCore
import Foundation

@objc public class KSGlobal: NSObject, JSExport
{
        public static var shared = KSGlobal()

        private var dummy: Int

        private override init(){
                dummy = 0
        }
}
