//
//  UIDropDown.swift
//  UIDropDown
//
//  Created by 5BG on 2015/7/14.
//  Copyright © 2015年 Sunny. All rights reserved.
//

import UIKit

class UIDropDown: NSObject, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate
{
    var dataArray = [String]()
    let toolbarStyle = UIBarStyle.Default
    var dropdownTable: UITableView?
    var textField: UITextField?
    var selectedValue: String?
    var singleTapGestureRecogniser: UITapGestureRecognizer = UITapGestureRecognizer()
    var orientation: UIInterfaceOrientation?

    init(textField: UITextField, dropdownlist: [String]){
        super.init()
        self.textField = textField
        self.dataArray = dropdownlist
        self.initDropDown()
    }

    func initDropDown() -> UIDropDown{
    
        self.textField!.placeholder = "Pick an option"
        let width: CGRect = self.textField!.frame
    
        if !dataArray.isEmpty
        {
            self.dropdownTable = UITableView(frame: CGRectMake(0, 0, self.textField!.frame.size.width, 0))
        
            self.dropdownTable?.delegate = self
            self.dropdownTable?.dataSource = self
        
            self.dropdownTable?.layer.borderColor = UIColor.greenColor().CGColor
            self.dropdownTable?.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            self.dropdownTable?.separatorColor = UIColor.whiteColor()
            self.dropdownTable?.alpha = 1.0
            let x = width.origin.x
            let y = width.origin.y + width.size.height + 10
            // show the dropdown list width and height
            self.dropdownTable?.frame = CGRectMake(x, y , width.size.width, 200)
            self.dropdownTable?.hidden = true
        
            self.textField!.delegate = self;
            self.textField!.addTarget(self, action: "selectedObjectClicked:", forControlEvents: UIControlEvents.TouchDown)
            self.textField?.userInteractionEnabled = true
            
            textField!.superview?.addSubview(dropdownTable!)
        }
    
        return self
    
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellIdentifier = "Cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell?
        
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        cell?.textLabel?.font =  UIFont.systemFontOfSize(15)
        cell?.textLabel?.textColor = UIColor.whiteColor()
        cell?.textLabel?.textAlignment = NSTextAlignment.Center
        cell?.textLabel!.text = dataArray[indexPath.row]
        cell?.backgroundColor = UIColor.grayColor()
    
        cell?.selectionStyle = UITableViewCellSelectionStyle.Blue
    
        return cell!
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedValue = dataArray[indexPath.row]
    
        // fade out menu
        self.dropdownTable!.alpha = 1.0;
        UIView.beginAnimations("Ending", context: nil)
        UIView.setAnimationDuration(0.3)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDidStopSelector("FadeOutComplete:")
        self.dropdownTable!.hidden = false
        self.dropdownTable!.alpha = 0.0
        UIView.commitAnimations()
        textField!.text = selectedValue
    }

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) ->Bool
    {
        if touch.view?.isDescendantOfView(self.dropdownTable!) != nil
        {
            // Don't let gesture recognizer fire if the table was touched
            return false
        }
        else{
            self.dismissMenu()
            return true
        }
    }

    func dismissMenu()
    {
        // remove the tap guesture recognizer and hide the menu
        textField!.superview!.removeGestureRecognizer(singleTapGestureRecogniser)
        NSNotificationCenter.defaultCenter().removeObserver(self)
        let endGeneratingDeviceOrientationNotifications = UIDevice.currentDevice()
        self.dropdownTable!.hidden = true
    
    }

    func didChangeOrientation(notification: NSNotification)
    {
        // remove the menu on rotation
        if (orientation != UIApplication.sharedApplication().statusBarOrientation)
        {
            orientation = UIApplication.sharedApplication().statusBarOrientation
        
            self.dismissMenu()
        }
    }

    func selectedObjectClicked(sender: AnyObject!)
    {
        let currentDeviceOrientation = UIDevice.beginGeneratingDeviceOrientationNotifications(UIDevice.currentDevice())
    
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "didChangeOrientation:",
            name: UIDeviceOrientationDidChangeNotification,
            object: UIDevice.currentDevice())
        // add touch detection on parent view, this will allow the menu to dissapear when the user touches outside of the menu.
        singleTapGestureRecogniser.numberOfTapsRequired = 1
        singleTapGestureRecogniser.delegate = self
        textField?.superview!.addGestureRecognizer(singleTapGestureRecogniser)
    
        self.dropdownTable!.alpha = 0.0
        UIView.beginAnimations("Zoom", context: nil)
        UIView.setAnimationDuration(0.3)
        self.dropdownTable!.hidden = false
        self.dropdownTable!.alpha = 1.0
        UIView.commitAnimations()
        self.dropdownTable!.scrollEnabled = true
        self.dropdownTable!.bounces = true
    }

    func FadeOutComplete()
    {
        self.dropdownTable!.alpha = 1.0
        self.dismissMenu()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
