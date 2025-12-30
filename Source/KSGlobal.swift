/**
 * @file        KSGlobalswift
 * @brief      Define KSGlobal class
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import JavaScriptCore
import Foundation

public class KSGlobal: JSExport
{
        public static var shared = KSGlobal()

        private var dummy: Int

        private init(){
                dummy = 0
        }
}
