/**
 * EnvVariables.d.ts
 */

declare class Environment
{
	getString(name: string): string | null ;
	setString(name: string, value: string): void ;
}

declare var env: Environment  ;

