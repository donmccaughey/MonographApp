//
//  TextCanvasView.swift
//  MonographApp
//
//  Created by Don McCaughey on 11/27/16.
//
//

import Cocoa
import CoreText
import monograph


class TextCanvasView: NSView {
    var document: Document?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        if document == nil {
            return
        }
        
        let graphicsContext = NSGraphicsContext.current!
        let context = graphicsContext.cgContext
        
        let font = NSFont.userFixedPitchFont(ofSize: 14.0)!
        let boundingRect = font.boundingRectForFont
        
        let size = mg_size_make(40, 40)
        let canvas = mg_canvas_alloc(size)
        mg_graph_draw(document?.graph, canvas)
        var text = canvas?.pointee.text
        var i = 0
        var x = CGFloat(0.0)
        var y = CGFloat(0.0)
        while (text?.pointee)! > 0 {
            let ch = text?.pointee
            if 0x0a == ch {
                x = 0.0
                y += boundingRect.size.height
            } else {
                let string = String(format: "%c", ch!)
                let text = NSTextStorage(string: string)
                text.font = font
                text.foregroundColor = NSColor.black
                
                context.textPosition = CGPoint(x: x, y: y)
                let line = CTLineCreateWithAttributedString(text)
                CTLineDraw(line, context)
                
                x += boundingRect.size.width
            }
            i += 1
            text = text?.advanced(by: 1)
        }
    }
}
