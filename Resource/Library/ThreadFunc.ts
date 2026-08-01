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

function startThread(thd: Thread, script: string): void
{
	thd.script = script ;
	thd.start() ;
}

function waitThread(thd: Thread): number
{
	while(thd.isRunning){
	}
	return thd.exitCode
}

