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

	/* return the process-id or null */
	run(): number | null ;
	wait(): void ;
}

declare function allocateURL(path: string): URL ;

