/**
 * @file math.ts
 */

/// <reference path="types/BuiltinLibrary.d.ts"/>

function abs(val: number): number
{
	return val >= 0.0 ? val : -val ;
}

