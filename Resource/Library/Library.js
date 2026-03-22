"use strict";
/**
 * @file Environment.ts
 */
/// <reference path="types/Library.d.ts"/>
class Env {
    set(name, value) {
        _env.set(name, value);
    }
    get(name) {
        return _env.get(name);
    }
}
