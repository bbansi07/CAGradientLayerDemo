//
//  ViewController.swift
//  CAGradientLayerDemo
//
//  Created by bansi bhatt on 04/08/17.
//
//

import UIKit

class ViewController: UIViewController,UIGestureRecognizerDelegate {

    var gradientLayer : CAGradientLayer!

    var arrcolorSets = [[CGColor]]()
    
    var colorIndex: Int!
    
    enum Directions: Int {
        case Right
        case Left
        case Bottom
        case Top
        case TopLeftToBottomRight
        case TopRightToBottomLeft
        case BottomLeftToTopRight
        case BottomRightToTopLeft
    }
    
    var directionPan: Directions!
    override func viewDidLoad() {
        super.viewDidLoad()
        arrcolorSets.append([UIColor.red.cgColor, UIColor.yellow.cgColor,UIColor.green.cgColor, UIColor.magenta.cgColor])
        colorIndex = 0
        addGestureRecognizer()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createGradientLayer()
    }
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        
        gradientLayer.colors = arrcolorSets[colorIndex]
        gradientLayer.locations = [0.0, 0.35,0.6,1.0]
       // gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
       // gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        
        self.view.layer.addSublayer(gradientLayer)
    }
    
    func addGestureRecognizer(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(gestureRecognizer:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        let twoFingerTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTwoFingerTapGesture(gestureRecognizer:)))
        twoFingerTapGestureRecognizer.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(twoFingerTapGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizer(gestureRecognizer:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
    }
   
    func handleTapGesture(gestureRecognizer: UITapGestureRecognizer) {
        if colorIndex < arrcolorSets.count - 1 {
            colorIndex! += 1
        }
        else {
            colorIndex = 0
        }
        
        let colorChangeAnimation = CABasicAnimation(keyPath: "colors")
        colorChangeAnimation.duration = 2.0
        colorChangeAnimation.toValue = arrcolorSets[colorIndex]
        colorChangeAnimation.fillMode = kCAFillModeForwards
        colorChangeAnimation.isRemovedOnCompletion = false
        
        gradientLayer.add(colorChangeAnimation, forKey: "colorChange")
    }
    func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradientLayer.colors = arrcolorSets[colorIndex]
        }
    }
    
    func handleTwoFingerTapGesture(gestureRecognizer: UITapGestureRecognizer) {
        let secondColorLocation = arc4random_uniform(100)
        let firstColorLocation = arc4random_uniform(secondColorLocation - 1)
        
        gradientLayer.locations = [NSNumber(value: Double(firstColorLocation)/100.0), NSNumber(value: Double(secondColorLocation)/100.0)]
        
        print(gradientLayer.locations!)
    }
    
    func handlePanGestureRecognizer(gestureRecognizer: UIPanGestureRecognizer) {
        let velocity = gestureRecognizer.velocity(in: self.view)
        
        if gestureRecognizer.state == UIGestureRecognizerState.changed {
            if velocity.x > 300.0 {
                // In this case the direction is generally towards Right.
               
                
                if velocity.y > 300.0 {
                    // Top-Left to Bottom-Right.
                    directionPan = Directions.TopLeftToBottomRight
                }
                else if velocity.y < -300.0 {
                    // Bottom-Left to Top-Right.
                    directionPan = Directions.BottomLeftToTopRight
                }
                else {
                    // towards Right.
                    directionPan = Directions.Right
                }
            }
            else if velocity.x < -300.0 {
                // In this case the direction is generally towards Left.
               
                
                if velocity.y > 300.0 {
                    // Movement from Top-Right to Bottom-Left.
                    directionPan = Directions.TopRightToBottomLeft
                }
                else if velocity.y < -300.0 {
                    // Movement from Bottom-Right to Top-Left.
                    directionPan = Directions.BottomRightToTopLeft
                }
                else {
                    // Movement towards Left.
                    directionPan = Directions.Left
                }
            }
            else {
                // In this case the movement is mostly vertical (towards bottom or top).
                
                if velocity.y > 300.0 {
                    // Movement towards Bottom.
                    directionPan = Directions.Bottom
                }
                else if velocity.y < -300.0 {
                    // Movement towards Top.
                    directionPan = Directions.Top
                }
                else {
                    // Do nothing.
                    directionPan = nil
                }
            }
        }
        else if gestureRecognizer.state == UIGestureRecognizerState.ended {
            changeGradientDirection()
        }
    }
    
    func changeGradientDirection() {
        if directionPan != nil {
            switch directionPan.rawValue {
            case Directions.Right.rawValue:
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
                
            case Directions.Left.rawValue:
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
                
            case Directions.Bottom.rawValue:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
                
            case Directions.Top.rawValue:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
                
            case Directions.TopLeftToBottomRight.rawValue:
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
                
            case Directions.TopRightToBottomLeft.rawValue:
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
                
            case Directions.BottomLeftToTopRight.rawValue:
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
                
            default:
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
            }
        }
    }
    
}

