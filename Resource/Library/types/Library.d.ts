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

declare class EnvironmentCore
{
	public get(name: String):  any ;
	public set(name: String, value: any) ;
}

declare var _env: EnvironmentCore ; // global

