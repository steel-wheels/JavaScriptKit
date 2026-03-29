/**
 * Environment.d.ts
 */

declare class Environment
{
	get(name: string): string | null ;
	set(name: string, value: string): void ;
}

declare var env: Environment  ;

