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
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "Document Window Controller") as! NSWindowController
        if let viewController = windowController.contentViewController as? ViewController {
            viewController.setDocument(document: self)
        }
        self.addWindowController(windowController)
    }

    override func data(ofType typeName: String) throws -> Data {
        var length: Int32 = 0
        let string = mg_graph_alloc_string(graph, &length)
        if (string == nil) {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(errno), userInfo: nil)
        }
        let bytes = UnsafeMutableRawPointer(string!)
        return Data(bytesNoCopy: bytes, count: Int(length), deallocator: .free)
    }

    override func read(from data: Data, ofType typeName: String) throws {
        NSLog("INFO: typeName = \"\(typeName)\"")
        var length: Int32 = 0
        let string = (data as NSData).bytes.bindMemory(to: Int8.self, capacity: data.count)
        let new_graph = mg_graph_alloc_from_string(string, &length)
        if (new_graph == nil) {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(errno), userInfo: nil)
        }
        if Int(length) < data.count {
            // TODO: should we check unread bytes at end of file, or
            // should libmonograph do this?
            NSLog("WARNING: did not read \(data.count - Int(length)) bytes of file")
        }
        mg_graph_free(graph)
        graph = new_graph!
    }
}
