/**
 * @file Process.d.ts 
 */

declare class URL {
	get path() : string ;
	appendingPathComponent(subpath: string): URL ;
}

declare function newURL(path: string): URL ;

