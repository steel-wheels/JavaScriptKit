/**
 * EnvVariables.d.ts
 */

declare class Environment
{
	getString(name: string): string | null ;
	setString(name: string, value: string): void ;

	getNumber(name: string): number | null ;
	setSNumber(name: string, value: number): void ;
}

declare var env: Environment  ;

