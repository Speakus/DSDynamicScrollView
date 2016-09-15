//
//  ExampleView.swift
//  DynamicScrollView
//
//  Created by Damir Stuhec on 03/10/14.
//  Copyright (c) 2014 damirstuhec. All rights reserved.
//

import UIKit
import Darwin

class ExampleView: DSDynamicView
{
    var nameLabel: UILabel
    var uniqueNumber: Int
    var distance: Int
    
    init(frame: CGRect, name: String)
    {
        nameLabel = UILabel(frame: frame)
        nameLabel.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        nameLabel.textAlignment = .Center
        nameLabel.text = name
        nameLabel.textColor = UIColor.whiteColor()
        
        uniqueNumber = 0
        distance = 0
        
        super.init(frame: frame)
        
        let hue = CGFloat(Float(arc4random() % 256) / 256.0)
        let saturation = CGFloat(Float(arc4random() % 128) / 256.0) + 0.5
        let brightness = CGFloat(Float(arc4random() % 128) / 256.0) + 0.5
        
        self.backgroundColor = UIColor(hue: CGFloat(hue),
                                       saturation: CGFloat(saturation),
                                       brightness: CGFloat(brightness),
                                       alpha: 1)
        self.addSubview(nameLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func isEqual(object: AnyObject?) -> Bool
    {
        if let anotherView = object as? ExampleView
        {
            return self.uniqueNumber == anotherView.uniqueNumber
        }
        else
        {
            return false
        }
    }
    
    override func compareToObject(object: AnyObject?) -> Bool
    {
        if let anotherView = object as? ExampleView
        {
            if self.distance > anotherView.distance
            {
                return false
            }
            else
            {
                return true
            }
        }
        else
        {
            return true
        }
    }
}
