/**
 * Builtin.d.ts
 */

declare function _log(message: string): void ;

/**
 * @file Process.d.ts 
 */

declare class URL {
	get path() : string ;
}

declare function newURL(path: string): URL ;

/**
 * EnvVariables.d.ts
 */

declare class Environment
{
	getString(name: string): string | null ;
	setString(name: string, value: string): void ;
}

declare var env: Environment  ;

/**
 * @file FileHandle.d.ts
 */
declare class FileHandle {
    setReader(func: (str: string) => void): void ;
    write(str: string): void ;
}

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

/**
 * isUndefined.d.ts
 */

declare function isUndefined(obj: unknown): boolean ;

