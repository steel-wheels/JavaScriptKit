/**
 * @file Thread.d.ts
 */

/// <reference path="FileHandle.d.ts"/>
/// <reference path="URL.d.ts"/>

declare class Thread
{
	get standardInput(): FileHandle ;
        set standardInput(hdl: FileHandle) ;

        get standardOutput(): FileHandle ;
        set standardOutput(hdl: FileHandle) ;

        get standardError(): FileHandle ;
        set standardError(hdl: FileHandle) ;

        get script(): string ;
        set script(hsrc: string) ;

        get arguments(): string[] | null ;
        set arguments(args: string[] | null) ;

        get executableURL(): URL | null ;
        set executableURL(url: URL | null) ;

	get isRunning(): boolean ;
	get exitCode(): number ;

	start(): void ;
}

declare function newThread(): Thread ;

