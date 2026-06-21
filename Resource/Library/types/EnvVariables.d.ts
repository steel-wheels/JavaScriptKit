/**
 * EnvVariables.d.ts
 */

declare class Environment
{
	getString(name: string): string | null ;
	setString(name: string, value: string): void ;

	getStrings(name: string): string[] | null ;
	setStrings(name: string, value: string[]): void ;

	getNumber(name: string): number | null ;
	setNumber(name: string, value: number): void ;

	getURL(name: string): URL | null ;
	setURL(name: string, value: URL): void ;

	getTextColor(name: string): TextColor | null ;
	setTextColor(name: string, value: TextColor): void ;

	getForegroundTextColor(): TextColor | null ;
	setForegroundTextColor(value: TextColor): void ;

	getBackgroundTextColor(): TextColor | null ;
	setBackgroundTextColor(value: TextColor): void ;
}

declare var env: Environment  ;

