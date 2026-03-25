/**
 * Builtin.d.ts
 */

declare function _log(message: string): void ;

/**
 * isUndefined.d.ts
 */

declare function isUndefined(obj: unknown): boolean ;

/**
 * EnvCore.d.ts
 */

declare class EnvCore
{
	public get(name: String): any ;
	public set(name: String, value: any): void ;
}

declare var _env: EnvCore ;

/**
 * @file FileHandle.d.ts
 */
declare class FileHandle {
    setReader(func: (str: string) => void): void ;
    write(str: string): void ;
}

/**
 * @file FileInterface.d.ts
 */
declare class FileInterface {
    inputFileHandle():  FileHandle ;
    outputFileHandle(): FileHandle ;
    errorFileHandle():  FileHandle ;
}
