//
//  ZYXStatePatternViewController.swift
//  DesignPatterns
//
//  Created by PengXiang on 2018/7/6.
//  Copyright © 2018年 PengXiang. All rights reserved.
//状态模式

import UIKit

class ZYXStatePatternViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let frame = CGRect(x: 100, y: 100, width: 150, height: 400)
        let lights: [SolidTrafficLightState] =
            [.greenLight(), .yellowLight(), .redLight()]
        let trafficLight = TrafficLightView(frame: frame, states: lights)
        view.addSubview(trafficLight)
    }
}
//在TrafficLightView中，我们默认用三个light container layers来分别放置不同颜色的light layer
final class TrafficLightView: UIView {
    
    // light container layers数组
    var lightContainerLayers: [CAShapeLayer] = []
    
    // 当前的状态
    private var currentState: TrafficLightState
    
    // 所有状态
    private var states: [TrafficLightState]
    
    // MARK: - Initializers
    
    init(frame: CGRect,
         lightsCount: Int = 3,
         states: [TrafficLightState]) {
        
        guard !states.isEmpty else { fatalError("states不能为空")}
        
        self.currentState = states.first!
        self.states = states
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 0.8, green: 0.6, blue: 0.3, alpha: 1)
        createLightContainerLayers(count: lightsCount)
        transition(to: currentState)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    // 下一个状态
    var nextState: TrafficLightState {
        guard let currentIndex = states.index(where: { $0 === currentState }),
            currentIndex + 1 < states.count else {
                return states.first!
        }
        return states[currentIndex + 1]
    }
    
    // 切换到指定的状态
    func transition(to state: TrafficLightState) {
        removeLightLayers()
        currentState = state
        currentState.apply(to: self)
        nextState.apply(to: self, after: currentState.delay)
    }
    
    // MARK: - Private
    
    // 创建light containers
    private func createLightContainerLayers(count: Int) {
        let yTotalPadding = 0.2 * frame.height
        let containerHeight = (frame.height - yTotalPadding) / CGFloat(count)
        
        let yPadding = yTotalPadding / CGFloat(count + 1)
        let xPadding = (frame.width - containerHeight) / 2.0
        
        var containerFrame = CGRect(x: xPadding,
                                    y: yPadding,
                                    width: containerHeight,
                                    height: containerHeight)
        
        for _ in 0 ..< count {
            let containerShape = CAShapeLayer()
            containerShape.path = UIBezierPath(ovalIn: containerFrame).cgPath
            containerShape.fillColor = UIColor.black.cgColor
            layer.addSublayer(containerShape)
            lightContainerLayers.append(containerShape)
            containerFrame.origin.y += (containerHeight + yPadding)
        }
    }
    
    // 移除所有light containers里面的light layers
    private func removeLightLayers() {
        lightContainerLayers.forEach {
            $0.sublayers?.forEach {
                $0.removeFromSuperlayer()
            }
        }
    }
}
//我们都知道，每个颜色的灯都会持续一段时间，所以规定需要一个delay属性；然后是把当前灯应用到context，所以规定apply(to context: TrafficLightView)方法。另外还通过扩展添加了一个方法，指定多少秒之后把当前状态应用到context，这样我们可以实现自动切换到下一个颜色的灯。
protocol TrafficLightState: class {
    var delay: TimeInterval { get }
    func apply(to context: TrafficLightView)
}

extension TrafficLightState {
    func apply(to context: TrafficLightView, after delay: TimeInterval) {
        DispatchQueue.main
            .asyncAfter(deadline: .now() + delay) { [weak self, weak context] in
                guard let strongSelf = self, let context = context else { return }
                context.transition(to: strongSelf)
        }
    }
}
//Solid在这里的意思指的是纯色，index表示在红绿灯中所在的位置。在apply(to context: TrafficLightView)的实现中: 先找到对应的container，然后创建light layer并设置颜色，最后把light layer加到对应的container中。另外还定义了默认的红灯、黄灯和绿灯。
final class SolidTrafficLightState: TrafficLightState {
    let index: Int
    let color: UIColor
    let delay: TimeInterval
    
    init(index: Int, color: UIColor, delay: TimeInterval) {
        self.index = index
        self.color = color
        self.delay = delay
    }
    
    func apply(to context: TrafficLightView) {
        let containerLayer = context.lightContainerLayers[index]
        let lightShape = CAShapeLayer()
        lightShape.path = containerLayer.path
        lightShape.fillColor = color.cgColor
        lightShape.strokeColor = color.cgColor
        containerLayer.addSublayer(lightShape)
    }
}

// MARK: - Lights
extension SolidTrafficLightState {
    class func redLight(index: Int = 0,
                        color: UIColor = .red,
                        delay: TimeInterval = 10) -> SolidTrafficLightState {
        return SolidTrafficLightState(index: index, color: color, delay: delay)
    }
    
    class func yellowLight(index: Int = 1,
                           color: UIColor = .yellow,
                           delay: TimeInterval = 3) -> SolidTrafficLightState {
        return SolidTrafficLightState(index: index, color: color, delay: delay)
    }
    
    class func greenLight(index: Int = 2,
                          color: UIColor = .green,
                          delay: TimeInterval = 10) -> SolidTrafficLightState {
        return SolidTrafficLightState(index: index, color: color, delay: delay)
    }
}
