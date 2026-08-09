/**
 * @file FileHandle.d.ts
 */
declare class FileHandle {
    setReader(func: (str: string) => void): void ;
    write(str: string): void ;
}

declare var standardInputFileHandle:	FileHandle  ;
declare var standardOutputFileHandle:	FileHandle  ;
declare var standardErrorFileHandle:	FileHandle  ;

