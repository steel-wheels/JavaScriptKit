/**
 * Process.d.ts
 */

/// <reference path="URL.d.ts"/>
/// <reference path="FileHandle.d.ts"/>

declare class Process {
	get standardInput(): FileHandle ;
	set standardInput(hdl: FileHandle) ;

	get standardOutput(): FileHandle ;
	set standardOutput(hdl: FileHandle) ;

	get standardError(): FileHandle ;
	set standardError(hdl: FileHandle) ;

	get executableURL(): URL ;
	set executableURL(url: URL) ;

	get arguments(): string[] ;
	set arguments(arg: string[]) ;

	get isRunning(): boolean ;
	get exitCode(): number ;

	start(): number ;
}

declare function newProcess(): Process ;

