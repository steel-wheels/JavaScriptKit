/**
 * @file Process.d.ts 
 */

declare class URL {
	get standardInput() : FileHandle ;
	set standardInput(file: FileHandle) ;

	get standardOutput() : FileHandle ;
	set standardOutput(file: FileHandle) ;

	get standardError() : FileHandle ;
	set standardError(file: FileHandle) ;

	get executableURL(): URL ;
	set executableURL(url: URL) ;

	get arguments(): string[] ;
	set arguments(args: string[]) ;

	/* return the process-id or null */
	run(): number | null ;
	wait(): void ;
}

declare function allocateURL(path: string): URL ;

