/**
 * @file Environment.ts
 */
declare class Env {
    set(name: string, value: any): void;
    get(name: string): any;
}
