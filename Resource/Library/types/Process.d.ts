/**
 * Process.d.ts
 */

declare class Process {
	get standardInput(): FileHandle ;
	set standardInput(hdl: FileHandle) ;

	get standardOutput(): FileHandle ;
	set standardOutput(hdl: FileHandle) ;

	get standardError(): FileHandle ;
	set standardError(hdl: FileHandle) ;

	run(): number ;
	wait(): void ;
}

declare function newProcess(): Process ;

