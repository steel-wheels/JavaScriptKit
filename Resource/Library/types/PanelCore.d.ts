/**
 * PanelCore.d.ts
 */

/// <reference path="URL.d.ts"/>

declare class OpenPanelCore {
	get selected():	   boolean ;
	get selectedURL(): URL | null ;
	show(title: string, type: number, extensions: string[]) : boolean ;
}

declare class SavePanelCore {
	get selected():	   boolean ;
	get selectedURL(): URL | null ;
	show(title: string, outdir: URL): boolean ;
}

declare function newOpenPanelCore(): OpenPanelCore ;
declare function newSavePanelCore(): SavePanelCore ;

