//
//  ViewController.swift
//  MonographApp_macos
//
//  Created by Don McCaughey on 6/5/16.
//
//

import Cocoa


class ViewController: NSViewController {
    var textCanvasView: TextCanvasView {
        return self.view as! TextCanvasView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setDocument(document: Document) {
        self.textCanvasView.document = document
    }
}
