//
//  MySubViewController.swift
//  SimpleRun
//
//  Created by JuRui on 14-9-15.
//  Copyright (c) 2014年 com.MySuperCompany. All rights reserved.
//

import UIKit

public class JRViewPickerView: UIView,UIPickerViewDataSource,UIPickerViewDelegate {
    
    //尺寸
    var _selfViewWeight:CGFloat = 320;
    var _selfViewHeight:CGFloat = 150;
    var _toolBarHeight:CGFloat = 30;
    var _pickerViewHeight:CGFloat = 120;
    
    
    //组件
    var _superView:UIView!;
    var _pickerView:UIPickerView!;
    var _toolbar:UIToolbar!;
    //数据
    var _columnsStringArrays:([[String]]) = [[String]]();
    var _defaultIndex:[Int] = [Int]();
    var _selectRange:Int = 0;
    //选择后的数据，用字符串数组
    var _selectedColumnsStringArray:[String] = [String]();
    //定义一个本地闭包
    var _completionClosure :((selectedStringArray:[String],selectedComponentsIndex:[Int])->Void)!;
    
    
    class var sharedInstance:JRViewPickerView {
        get{
            struct Static {
                static let instance:JRViewPickerView = JRViewPickerView()
            }
            return Static.instance;
        }
    }
    
    override init() {
        super.init();
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    // -MARK: 弹出窗口
    class func showJRPickerViewInSuperView(view:UIView,withColumnsStringArrays columnsStringArrays:([[String]])!,withDefaultIndex defaultIndex:[Int],andSelectInRange selectRange:Int,withCompletionClosure completionClosure:((selectedColumnsStringArray:[String],selectedComponentsIndex:[Int])->Void)!){
        
        //数据
        self.sharedInstance._columnsStringArrays = columnsStringArrays;
        self.sharedInstance._defaultIndex = defaultIndex;
        self.sharedInstance._selectRange = selectRange;
        self.sharedInstance._completionClosure = completionClosure;
        //清空
        self.sharedInstance._selectedColumnsStringArray = [String]();
        
        //UIViews
        self.sharedInstance._superView = view;
        self.sharedInstance.frame = CGRect(x: 0, y: view.frame.height-self.sharedInstance._selfViewHeight, width: view.frame.width, height: self.sharedInstance._selfViewHeight);
        self.sharedInstance.backgroundColor = UIColor.grayColor();
        //这里也要让pickerview为空，同hideJRPickerViewWithSelect里的原因一样，如果不清空，选好了两个，点击一个但是不点击取消或者确认按钮，点击另外一个，就会异常
        self.removeAllSubviewFromJRPickerView();

        //虽然前面已经清空，这里还是要写一下
        if(self.sharedInstance._pickerView == nil)
        {
            //init and add PickerView
            self.sharedInstance._pickerView = UIPickerView(frame: CGRect(x: 0, y: self.sharedInstance.frame.height-self.sharedInstance._pickerViewHeight, width: self.sharedInstance._superView.frame.width, height: 100));
            self.sharedInstance._pickerView.delegate = self.sharedInstance;
            self.sharedInstance._pickerView.dataSource = self.sharedInstance;
            self.sharedInstance.addSubview(self.sharedInstance._pickerView);
        }
        
        //如果没有设定初始值，一般来说是第一次点
        if(self.sharedInstance._defaultIndex.count > 0){
            for(var i:Int=0;i < self.sharedInstance._selectRange;i++){
                self.sharedInstance._pickerView.selectRow(self.sharedInstance._defaultIndex[i], inComponent:i, animated: true);
            }
        }
        
        if(self.sharedInstance._toolbar == nil){
            //init and add Toolbar
            self.sharedInstance._toolbar = UIToolbar(frame: CGRect(x: 0, y: self.sharedInstance._pickerView.frame.origin.y-self.sharedInstance._toolBarHeight, width: view.frame.width, height: self.sharedInstance._toolBarHeight));
            self.sharedInstance.addSubview(self.sharedInstance._toolbar);
            //init and add Toolbar items
            var myToolBarItems:[AnyObject] = [AnyObject]();
            myToolBarItems.append(UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Bordered, target: self, action: "hideJRPickerViewWithoutSelect"))
            myToolBarItems.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil));
            myToolBarItems.append(UIBarButtonItem(title: "确定", style: UIBarButtonItemStyle.Bordered, target: self, action: "hideJRPickerViewWithSelect"))
            self.sharedInstance._toolbar.setItems(myToolBarItems, animated: true);
            
        }
        self.sharedInstance._pickerView.reloadAllComponents()
        view.addSubview(self.sharedInstance)
        
    }
    
    //隐藏窗口
    
    class func hideJRPickerViewWithoutSelect(){
        //要把pickerview对象清空，不然当选择了M列时，再选择N列（M>N）时，component 列的索引不会从0开始
        self.removeAllSubviewFromJRPickerView();
        //动画
        var animationDuration:NSTimeInterval = 1;
        UIView.beginAnimations("hideJRPickerViewWithoutSelect", context: nil);
        UIView.setAnimationDuration(animationDuration);
        self.sharedInstance.frame.origin.y = self.sharedInstance._superView.frame.origin.y + self.sharedInstance.frame.origin.y;
        //移除
        self.sharedInstance.removeFromSuperview();
        UIView.commitAnimations();

    }
    
    class func hideJRPickerViewWithSelect(){
        
        //存储选中的索引
        //如果传就来的已经是有默认值的，那么就不能直接append了，要先清空
        if(self.sharedInstance._defaultIndex.count > 0)
        {
            self.sharedInstance._defaultIndex = [Int]();
        }
        
        for(var i:Int = 0; i < self.sharedInstance._selectRange; i++){
            var row:Int = self.sharedInstance._pickerView.selectedRowInComponent(i);
            //将取得的数据先存放在本地字段
            self.sharedInstance._selectedColumnsStringArray.append(self.sharedInstance._columnsStringArrays[i][row]);
            //将取得数据的索引存放在本地字段
            self.sharedInstance._defaultIndex.append(row);
        }
        
        //传入闭包参数
        self.sharedInstance._completionClosure(selectedStringArray:self.sharedInstance._selectedColumnsStringArray,selectedComponentsIndex:self.sharedInstance._defaultIndex);
       
        //动画
        var animationDuration:NSTimeInterval = 1;
        UIView.beginAnimations("hideJRPickerViewWithSelect", context: nil);
        UIView.setAnimationDuration(animationDuration);
        //要把pickerview对象清空，不然当选择了M列时，再选择N列（M>N）时，component 列的索引不会从0开始
        self.removeAllSubviewFromJRPickerView();

        self.sharedInstance.frame.origin.y = self.sharedInstance._superView.frame.origin.y + self.sharedInstance.frame.origin.y;
        //移除
        self.sharedInstance.removeFromSuperview();
        UIView.commitAnimations();

        
    }
    // -MARK:方法：从JRPickerView上移除所有控件
    class func removeAllSubviewFromJRPickerView(){
        if(self.sharedInstance._toolbar != nil)
        {
            self.sharedInstance._toolbar.removeFromSuperview();
            self.sharedInstance._toolbar = nil;
        }
        if(self.sharedInstance._pickerView != nil)
        {
            self.sharedInstance._pickerView.removeFromSuperview();
            self.sharedInstance._pickerView = nil;
        }
    }
    
    
    //- MARK: UIPickerViewDataSource Funs
    
    // returns the number of 'columns' to display.
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return self._columnsStringArrays.count;
    }
    
    // returns the # of rows in each component..
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return self._columnsStringArrays[component].count;
    }
    
    //- MARK: UIPickerViewDelegate Funs
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!{
        return self._columnsStringArrays[component][row];
        
    }
    
    public func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20;
    }
    
    public func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return CGFloat(Int(self.frame.width)/self._columnsStringArrays.count);
    }
    
    
}
