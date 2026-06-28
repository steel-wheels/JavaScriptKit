/**
 * @file Console.ts
 */

/// <reference path="types/FileHandle.d.ts"/>

class Console
{
        log(str: string): void {
                stdout.write(str) ;
        }
}
