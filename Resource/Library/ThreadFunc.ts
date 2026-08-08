/**
 * @file ThreadFunc.ts
 */

/// <reference path="types/Thread.d.ts"/>

function allocateThread(inf: FileHandle, outf: FileHandle,
			 errf: FileHandle): Thread
{
	let thd = newThread() ;
	thd.standardInput	= inf ;
	thd.standardOutput	= outf ;
	thd.standardError	= errf ;
	return thd ;
}

function startThreadWithScript(thd: Thread, args: string[],
			       script: string): void
{
	thd.script    = script ;
	thd.arguments = args ;
	thd.start() ;
}

function startThreadWithFile(thd: Thread, args: string[], url: URL): void
{
	thd.executableURL  = url ;
	thd.arguments	   = args ;
	thd.start() ;
}

function waitThread(thd: Thread): number
{
	while(thd.isRunning){
	}
	return thd.exitCode
}

