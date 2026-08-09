/**
 * @file Console.ts
 */

/// <reference path="types/FileHandle.d.ts"/>

class Console
{
        log(str: string): void {
                standardOutputFileHandle.write(str) ;
        }
}

var console = new Console() ;

