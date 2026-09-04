/*
 * @file FileSelector.ts
 */

/// <reference path="types/URL.d.ts"/>
/// <reference path="types/PanelCore.d.ts"/>

function selectFileToOpen(title: string, type: number, extensions: string[]): URL | null {
        let panel = newOpenPanelCore() ;
        panel.show(title, type, extensions) ;
        while(!panel.selected){
                /* wait */
        }
        return panel.selectedURL ;
}

function selectFileToSave(title: string, outdir: URL): URL | null {
        let panel = newSavePanelCore() ;
        panel.show(title, outdir) ;
        while(!panel.selected){
                /* wait */
        }
        return panel.selectedURL ;
}