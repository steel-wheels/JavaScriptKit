"use strict";
/**
 * @file Console.ts
 */
/// <reference path="types/FileHandle.d.ts"/>
class Console {
    log(str) {
        standardOutputFileHandle.write(str);
    }
}
var console = new Console();
