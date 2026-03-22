/**
 * @file Environment.ts
 */

/// <reference path="types/Library.d.ts"/>

class Env
{       
        set(name: string, value: any) : void {
                _env.set(name, value) ;
        }

        get(name: string): any {
                return _env.get(name) ;
        }
}
