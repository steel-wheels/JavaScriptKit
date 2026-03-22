/**
 * Environment.d.ts
 */

declare class EnvironmentCore
{
	public get(name: String):  any ;
	public set(name: String, value: any) ;
}

declare var _env: EnvironmentCore ; // global

