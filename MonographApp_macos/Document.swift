//
//  Document.swift
//  MonographApp_macos
//
//  Created by Don McCaughey on 6/5/16.
//
//

import Cocoa
import Darwin.C.errno
import monograph


class Document: NSDocument {
    var graph: UnsafeMutablePointer<mg_graph>
    
    override init() {
        graph = mg_graph_alloc()
        super.init()
    }
    
    deinit {
        mg_graph_free(graph)
    }
    
    override class func autosavesInPlace() -> Bool {
        return true
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateControllerWithIdentifier("Document Window Controller") as! NSWindowController
        self.addWindowController(windowController)
    }

    override func dataOfType(typeName: String) throws -> NSData {
        var length: Int32 = 0
        let string = mg_graph_alloc_string(graph, &length)
        if (string == nil) {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(errno), userInfo: nil)
        }
        return NSData(bytesNoCopy: string, length: Int(length), freeWhenDone: true)
    }

    override func readFromData(data: NSData, ofType typeName: String) throws {
        NSLog("INFO: typeName = \"\(typeName)\"")
        var length: Int32 = 0
        let string = UnsafePointer<Int8>(data.bytes)
        let new_graph = mg_graph_alloc_from_string(string, &length)
        if (new_graph == nil) {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(errno), userInfo: nil)
        }
        if Int(length) < data.length {
            // TODO: should we check unread bytes at end of file, or
            // should libmonograph do this?
            NSLog("WARNING: did not read \(data.length - Int(length)) bytes of file")
        }
        mg_graph_free(graph)
        graph = new_graph
    }
}
