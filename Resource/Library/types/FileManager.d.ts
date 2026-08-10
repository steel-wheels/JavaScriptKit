/**
 * FileManager.d.ts
 */

/// <reference path="types/URL.d.ts"/>

declare class FileManager
{
	isExist(url: URL): boolean ;
	isExecutable(url: URL): boolean ;
}

declare var fileManager: FileManager  ;

