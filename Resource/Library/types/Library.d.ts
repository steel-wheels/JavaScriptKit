/**
 * Builtin.d.ts
 */

declare function _log(message: string): void ;

/**
 * isUndefined.d.ts
 */

declare function isUndefined(obj: unknown): boolean ;

/**
 * Environment.d.ts
 */

declare class Environment
{
	public get(name: String):  any ;
	public set(name: String, value: any) ;
}

/**
 * GlobalVariables.d.ts: define global variables
 */

declare var env: Environment ; // global

