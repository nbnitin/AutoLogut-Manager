//
//  AutLogoutManager.swift
//  Superplum
//
//
//  Copyright © 2020 Nitin. All rights reserved.
//
//this class is responsible to autologout user from the application

import Foundation
import UIKit

extension NSNotification.Name {
   public static let TimeOutUserInteraction: NSNotification.Name = NSNotification.Name(rawValue: "TimeOutUserInteraction")
}


fileprivate var timer : Timer!

@objc public class CatchAllGesture : UIGestureRecognizer {

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
    }
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        //reset your timer here
        state = .failed
        resetTimer()
        super.touchesEnded(touches, with: event)
    }
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
    }
    
    func resetTimer(){
        timer.invalidate()
        timer = startTimer()
    }
    
    func startTimer()->Timer{
      return  Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: {_ in
            NotificationCenter.default.post(name:.TimeOutUserInteraction, object: nil)
            print("hello logout")
        })
    }
}

@objc extension AppDelegate {

    func addGesture () {
        let aGesture = CatchAllGesture(target: nil, action: nil)
        aGesture.cancelsTouchesInView = false
        self.window!.addGestureRecognizer(aGesture)
        timer = aGesture.startTimer()
    }
}


//call add gesture function in AppDelegate's
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        addGesture()        
        return true
    }
    
    //Implement notification in vc view did load
    // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(logOut), name: .TimeOutUserInteraction, object: nil)
         @objc func logOut(){
        self.navigationController?.popViewController(animated: true)
    }
