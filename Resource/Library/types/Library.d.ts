/**
 * Builtin.d.ts
 */

declare function _log(message: string): void ;

/**
 * URLd.ts
 */

declare class Process {
	wait(): void
}

declare function allocateProcess(): Process ;

/**
 * Environment.d.ts
 */

declare class Environment
{
	get(name: string): string | null ;
	set(name: string, value: string): void ;
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
 * @file FileInterface.d.ts
 */
declare class FileInterface {
    inputFileHandle():  FileHandle ;
    outputFileHandle(): FileHandle ;
    errorFileHandle():  FileHandle ;
}
/**
 * @file Process.d.ts 
 */

declare class URL {
	get fileInterface(): FileInterface ;
	set fileInterface(intf: FileInterface) ;

	get executableURL(): URL ;
	set executableURL(url: URL) ;

	get arguments(): string[] ;
	set arguments(args: string[]) ;

	run(): boolean ;
	wait(): void ;
}

declare function allocateURL(path: string): URL ;

/**
 * isUndefined.d.ts
 */

declare function isUndefined(obj: unknown): boolean ;

/**
 * @file math.ts
 */
declare function abs(val: number): number;
