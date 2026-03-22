/**
 * EnvCore.d.ts
 */

declare class EnvCore
{
	public get(name: String): any ;
	public set(name: String, value: any): void ;
}

declare var _env: EnvCore ;

