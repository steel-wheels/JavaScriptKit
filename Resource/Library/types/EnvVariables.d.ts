/**
 * EnvVariables.d.ts
 */

/// <reference path="types/TextColor.d.ts"/>

declare class Environment
{
	get allKeys(): string[] ;

	get(name: string): string | null ;
	set(name: string, value: string): void ;
}

declare var env: Environment  ;

