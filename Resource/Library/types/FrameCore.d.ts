/*
 * FrameCore.d.ts
 */

interface FrameCoreIF {
  _value(p0: string): any ;
  _setValue(p0: string, p1: any): boolean ;
  _addObserver(p0: string, p1: () => void): void ;
}

