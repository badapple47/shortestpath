//
//  ViewController.swift
//  check
//
//  Created by Pathompong Chaisri on 10/27/2560 BE.
//  Copyright © 2560 Pathompong Chaisri. All rights reserved.
//

import UIKit

var sumWeight : Double! = 0

let Entrance1 = MyNode(name: "Entrance1")
let Node2 = MyNode(name: "Node2")
let Ladder1 = MyNode(name: "Ladder1")
let Node3 = MyNode(name: "Node3")
let Node4 = MyNode(name: "Node4")
let Toilet1Man = MyNode(name: "Toilet1Man")
let Toilet1Woman = MyNode(name: "Toilet1Woman")


class ViewController: UIViewController {

    @IBAction func activateSP(_ sender: Any) {
        
        Entrance1.connections.append(Connection(to: Node2, weight: 5))
        Node2.connections.append(Connection(to: Ladder1, weight: 1.4))
        Node2.connections.append(Connection(to: Node3, weight: 1.625))
        Node2.connections.append(Connection(to: Entrance1, weight: 5))
        Ladder1.connections.append(Connection(to: Node2, weight: 1))
        Node3.connections.append(Connection(to: Node2, weight: 1))
        Node3.connections.append(Connection(to: Node4, weight: 10.7))
        
        
        let sourceNode = Entrance1
        let destinationNode = Node2
        
        var path = shortestPath(source: sourceNode, destination: destinationNode)
        
        if let succession: [String] = path?.array.reversed().flatMap({ $0 as? MyNode}).map({$0.name}) {
            print("Destination From \(sourceNode.name) to \(destinationNode.name)")
            print("🏁 Quickest path: \(succession)")
            print("🏁 Quickest Weight: \(sumWeight)")
        } else {
            print("💥 No path between \(sourceNode.name) & \(destinationNode.name)")
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

}


class Node {
    var visited = false
    var connections: [Connection] = []
}

class Connection {
    public let to: Node
    public let weight: Double
    
    public init(to node: Node, weight: Double) {
        assert(weight >= 0, "weight has to be equal or greater than zero")
        self.to = node
        self.weight = weight
    }
}

class Path {
    public let cumulativeWeight: Double
    public let node: Node
    public let previousPath: Path?
    
    init(to node: Node, via connection: Connection? = nil, previousPath path: Path? = nil) {
        if
            let previousPath = path,
            let viaConnection = connection {
            self.cumulativeWeight = viaConnection.weight + previousPath.cumulativeWeight
            sumWeight = self.cumulativeWeight
        } else {
            self.cumulativeWeight = 0
        }
        
        self.node = node
        self.previousPath = path
    }
}

extension Path {
    var array: [Node] {
        var array: [Node] = [self.node]
        
        var iterativePath = self
        while let path = iterativePath.previousPath {
            array.append(path.node)
            
            iterativePath = path
        }
        
        return array
    }
}

func shortestPath(source: Node, destination: Node) -> Path? {
    var frontier: [Path] = [] {
        didSet { frontier.sort { return $0.cumulativeWeight < $1.cumulativeWeight } } // the frontier has to be always ordered
    }
    
    frontier.append(Path(to: source)) // the frontier is made by a path that starts nowhere and ends in the source
    
    while !frontier.isEmpty {
        let cheapestPathInFrontier = frontier.removeFirst() // getting the cheapest path available
        guard !cheapestPathInFrontier.node.visited else { continue } // making sure we haven't visited the node already
        
        if cheapestPathInFrontier.node === destination {
            return cheapestPathInFrontier // found the cheapest path 😎
        }
        
        cheapestPathInFrontier.node.visited = true
        
        for connection in cheapestPathInFrontier.node.connections where !connection.to.visited { // adding new paths to our frontier
            frontier.append(Path(to: connection.to, via: connection, previousPath: cheapestPathInFrontier))
        }
    } // end while
    return nil // we didn't find a path 😣
}


class MyNode: Node {
    let name: String
    
    init(name: String) {
        self.name = name
        super.init()
    }
}


