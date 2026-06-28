/**
 * @file FileHandle.d.ts
 */
declare class FileHandle {
    setReader(func: (str: string) => void): void ;
    write(str: string): void ;
}

declare var stdin:	FileHandle  ;
declare var stdout:	FileHandle  ;
declare var stderr:	FileHandle  ;

