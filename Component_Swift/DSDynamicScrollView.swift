//
//  DSDynamicScrollView.swift
//  DynamicScrollView
//
//  Created by Damir Stuhec on 03/10/14.
//  Copyright (c) 2014 damirstuhec. All rights reserved.
//

import UIKit

class DSDynamicScrollView : UIScrollView
{
    let kAnimationTime = 0.2
    let defaultMargin: CGFloat = 15.0
    let smallMargin: CGFloat = 7.0

    var maxNumberOfViewsPerPage: Int = 5
    var locked: Bool = false
    var views = [DSDynamicView]()
    var viewSize: CGSize = CGSizeZero

    func updateViewsWithArray(let array: [DSDynamicView])
    {
        if !self.locked
        {
            var viewsToKeep = [DSDynamicView]()
            var viewsToAdd = [DSDynamicView]()
            var viewsToRemove = self.views

            for aView in array
            {
                if viewsToRemove.contains(aView)
                {
                    if let index = viewsToRemove.indexOf(aView)
                    {
                        viewsToRemove.removeAtIndex(index)
                    }

                    viewsToKeep.append(aView)
                }
                else
                {
                    viewsToAdd.append(aView)
                }
            }

            self.views = array.sort {
                (obj1: DSDynamicView, obj2: DSDynamicView) -> Bool in
                return obj1.compareToObject(obj2)
            }

            self.calculateViewSize()

            self.updateRemovingViewsWithAnimation(viewsToRemove, animation:true, completionHandler: { () -> Void in
                self.repositionKeepingViewsWithAnimation(viewsToKeep, animation:true, completionHandler: { () -> Void in
                    self.updateAddingViewsWithAnimation(viewsToAdd, animation:true, completionHandler: { () -> Void in
                    })
                })
            })
        }
    }

    // MARK: Helper methods

    func updateRemovingViewsWithAnimation(removingViews: [DSDynamicView],
                                          let animation: Bool,
                                              completionHandler:() -> Void)
    {
        if removingViews.count == 0
        {
            completionHandler()
            return
        }

        var counter = 0

        for aView in removingViews
        {
            let animationTime = (animation) ? kAnimationTime : 0.0
            UIView.animateWithDuration(
                animationTime,
                animations:
                { () -> Void in
                    var newFrame = aView.frame
                    newFrame.origin.x = 320.0
                    aView.frame = newFrame
                },
                completion:
                { (finished) -> Void in
                    aView.removeFromSuperview()
                    counter += 1

                    if counter == removingViews.count
                    {
                        completionHandler()
                    }
                }
            )
        }
    }

    func repositionKeepingViewsWithAnimation(keepingViews: [DSDynamicView],
                                             let animation: Bool,
                                                 completionHandler:() -> Void)
    {
        if keepingViews.count == 0
        {
            completionHandler()
            return
        }

        var counter = 0

        for aView in keepingViews
        {
            let viewIndex = CGFloat(self.views.indexOf(aView)!)
            let viewY = viewIndex * (self.viewSize.height + self.defaultMargin)

            let animationTime = (animation) ? kAnimationTime : 0.0
            UIView.animateWithDuration(
                animationTime,
                animations:
                { () -> Void in
                    var newFrame = aView.frame
                    newFrame.origin.y = viewY
                    newFrame.size = self.viewSize
                    aView.frame = newFrame
                },
                completion:
                { (finished) -> Void in
                    counter += 1

                    if counter == keepingViews.count {
                        completionHandler()
                    }
                }
            )
        }
    }

    func updateAddingViewsWithAnimation(addingViews: [DSDynamicView],
                                        let animation: Bool,
                                            completionHandler: () -> Void)
    {
        if addingViews.count == 0
        {
            completionHandler()
            return
        }

        var counter = 0

        for aView in addingViews
        {
            let viewIndex = CGFloat(self.views.indexOf(aView)!)
            let viewY = viewIndex * (self.viewSize.height + self.defaultMargin)

            aView.frame = CGRectMake(-320.0, viewY, self.viewSize.width, self.viewSize.height)
            self.addSubview(aView)

            let animationTime = (animation) ? kAnimationTime : 0.0
            UIView.animateWithDuration(
                animationTime,
                animations:
                { () -> Void in
                    var newFrame = aView.frame
                    newFrame.origin.x = 0.0
                    aView.frame = newFrame
                },
                completion:
                { (finished) -> Void in
                    counter += 1

                    if counter == addingViews.count {
                        completionHandler()
                    }
                }
            )
        }
    }

    func calculateViewSize()
    {
        let viewsCountWithLimit = (self.views.count > maxNumberOfViewsPerPage) ? maxNumberOfViewsPerPage : self.views.count
        self.viewSize = CGSizeMake(self.frame.size.width, (self.frame.size.height - self.contentInset.top - self.contentInset.bottom - ((CGFloat(viewsCountWithLimit) - 1) * self.defaultMargin)) / CGFloat(viewsCountWithLimit))
    }
}
