//
//  ZYXCommandViewController.swift
//  DesignPatterns
//
//  Created by PengXiang on 2018/7/7.
//  Copyright © 2018年 PengXiang. All rights reserved.
//命令模式

import UIKit

class ZYXCommandViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let door = Door()
        let doorman = DoorMan(door: door)
        
        doorman.openDoor()
        doorman.closeDoor()
        
    }
}
//1) 首先定义了Door，只有一个属性isOpen；2) DoorCommand作为一个基类，持有door属性，还有一个命令执行的方法excecute()；3) 分别创建开门和关门的命令。
final class Door {
    var isOpen = false
}
class DoorCommand {
    let door : Door
    init(door : Door) {
        self.door = door
    }
    func execute() {}
}
final class OpenCommand: DoorCommand {
    override func execute() {
        print("正在开门")
        door.isOpen = true
    }
}
final class CloseCommand: DoorCommand {
    override func execute() {
        print("正在关门")
        door.isOpen = false
    }
}
//这里定义了Doorman，角色属于 Invoker，持有Door和开关门的命令，另外还定义了发送开关门命令的方法。
class DoorMan  {
    let door : Door
    let closeCommand : CloseCommand
    let openCommand : OpenCommand
    init(door : Door) {
        self.door = door
        self.closeCommand = CloseCommand(door: door)
        self.openCommand = OpenCommand(door: door)
    }
    func closeDoor() {
        closeCommand.execute()
    }
    func openDoor() {
        openCommand.execute()
    }
}
