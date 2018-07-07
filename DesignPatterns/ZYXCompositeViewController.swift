//
//  ZYXCompositeViewController.swift
//  DesignPatterns
//
//  Created by PengXiang on 2018/7/7.
//  Copyright © 2018年 PengXiang. All rights reserved.
// 组合模式

import UIKit

class ZYXCompositeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // 创建两个文件夹
        let desktop = Folder(name: "桌面")
        let musicFolder = Folder(name: "我最爱的音乐")
        
        // 创建具体的文件
        let iOSDesignPattern = PDF(name: "iOS设计模式")
        
        let diYiCi = Music(name: "第一次", artist: "光良")
        let liXiang = Music(name: "理想", artist: "赵雷")
        
        // 桌面文件夹添加音乐文件夹和 PDF 文件
        desktop.addFile(musicFolder)
        desktop.addFile(iOSDesignPattern)
        
        // 把两个音乐添加到音乐文件夹
        musicFolder.addFile(diYiCi)
        musicFolder.addFile(liXiang)
        
        // 打开文件
        iOSDesignPattern.open()
        liXiang.open()
        
        // 打开文件夹
        desktop.open()
        musicFolder.open()
    }
}
//定义了File协议，所有的 Leaf 和 Composite 对象都要遵循这个协议
protocol File {
    var name : String { set get }
    func open()
}
//定义了两个 Leaf 类型，分别是PDF和Music，并且遵循File协议，各自实现了open()方法。
final class PDF : File {
    var name: String
    
    init(name:String) {
        self.name = name
    }
    func open() {
        print("正在打开\(name)")
    }
}
final class Music: File {
    var name: String
    var artist : String
    init(name : String ,artist : String) {
        self.name = name
        self.artist = artist
    }
    func open() {
        print("正在播放\(artist)的\(name)")
    }
}
//Folder属于 Composite，实现了File协议，另外有一个数组可以存储其他 File 类型，也就意味着 Folder不仅可以存储PDF和Music，也可以存储其他Folder对象。
final class Folder: File {
    var name: String
    private(set) var files : [File] = []
    init(name:String) {
        self.name = name
    }
    func addFile(_ file : File) -> Void {
        files.append(file)
    }
    func open() {
        print("\n")
        print("正在显示以下文件：")
        files.forEach { print("--- \($0.name)") }
    }
}
