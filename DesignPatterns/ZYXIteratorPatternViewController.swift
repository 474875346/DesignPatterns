//
//  ZYXIteratorPatternViewController.swift
//  DesignPatterns
//
//  Created by PengXiang on 2018/7/6.
//  Copyright © 2018年 PengXiang. All rights reserved.
//

import UIKit

class ZYXIteratorPatternViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let lebron = Person(name: "Lebron James")
        let love = Person(name: "Kevin Love")
        let korver = Person(name: "Kyle Korver")
        
        // 入队
        var queue = Queue<Person>()
        queue.enqueue(lebron)
        queue.enqueue(love)
        queue.enqueue(korver)
        
        // 出队
        queue.dequeue()
        
        for person in queue {
            print(person?.name ?? "此人不存在")
        }

    }
}
struct Queue<T> {
    private var array : [T?] = []
    private var head = 0
    var isEmpty : Bool {
        return count == 0
    }
    var count: Int {
        return array.count - head
    }
    
    mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    mutating func dequeue() -> T? {
        guard head < array.count,
            let element = array[head] else {
                return nil
        }
        array[head] = nil
        head += 1
        return element
    }
}
extension Queue: Sequence {
    func makeIterator() -> IndexingIterator<ArraySlice<T?>> {
        let values = array[head..<array.count]
        return values.makeIterator()
    }
}
struct Person {
    let name: String
}

