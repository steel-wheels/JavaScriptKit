/**
 * Value.d.ts
 */

/// <reference path="types/URL.d.ts"/>

/* The raw value for value must be compatible with MIValue.swift */
declare enum ValueType
{
        nilType                 = 0,
        booleanType             = 1,
        //ignedIntType          = 2,
        //unsignedIntType       = 3,
        numberType              = 4,
        stringType              = 5,
        arrayType               = 6,
        dictionaryType          = 7
}

declare interface ValueDictionary {
  [key: string]: Value;
}

declare class Value
{
        get type(): ValueType ;

        setNullValue(): void ;

        set booleanValue(val: boolean) ;
        get booleanValue(): boolean ;

        set numberValue(val: number) ;
        get numberValue(): number ;

        set stringValue(val: string) ;
        get stringValue(): string ;

        set arrayValue(val: Value[]) ;
        get arrayValue(): Value[] ;

        set dictionaryValue(val: ValueDictionary) ;
        get dictionaryValue(): ValueDictionary ;
}

/* initial value: null */
declare function newValue(): Value ;

