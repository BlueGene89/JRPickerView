// Make a JRPickerView in singleton instance way as a field of the DemoViewController class
var jrViewPickerView:JRViewPickerView = JRViewPickerView.sharedInstance;




//usage like this

//make an [Int] like this to make the default select index and restore select index when picker at a row;
//Notice:the count of these array should = selectRange <= Component

var lastHeightSelectedIndex:[Int] = [Int]();

var lastWeightSelectedIndex:[Int] = [Int]();


    func tapAction(sender:UIGestureRecognizer){

        if(sender.self.view == self.userHeightLabel){
            NSLog("click UserHeightLabel");
            
            //the data string you want to put in
            //Notice:the data string count should >= the range you want to select in picker view
            var columnStringArrays:[[String]] = [[String]]();
            
            var userHeight:[String] = [String]();
            //Height：100～250 cm
            for i in 150...250{
                userHeight.append("\(i as Int)");
            }
            columnStringArrays.append(userHeight);
            columnStringArrays.append(["CM"]);
            //call the show method of the JRViewPickerView singleton instance
            
            JRViewPickerView.showJRPickerViewInSuperView(self.view, withColumnsStringArrays: columnStringArrays, withDefaultIndex: self.lastHeightSelectedIndex, andSelectInRange: 1) { (selectedColumnsStringArray, selectedComponentsIndex) -> Void in
                self.userHeightLabel.text = "";
                for text in selectedColumnsStringArray{
                    
                    self.userHeightLabel.text! += text;
                    
                }
                //set the select index so that the next time would select the index in default
                self.lastHeightSelectedIndex = selectedComponentsIndex;
            }

            
        }
        else if(sender.self.view == self.userWeightLabel){
            NSLog("click UserWeightLabel");
            
            var columnStringArrays:[[String]] = [[String]]();
            var userWeight:[String] = [String]();
            //Weight：50～200 Kg
            for i in 50...180{
                userWeight.append("\(i as Int)");
            }
            var userWeightPoint:[String] = [String]();
            //Points：0.1～0.9 Kg
            for i in 1...9{
                userWeightPoint.append(".\(i as Int)");
            }
            
            columnStringArrays.append(userWeight);
            columnStringArrays.append(userWeightPoint);
            columnStringArrays.append(["Kg"]);
            
            JRViewPickerView.showJRPickerViewInSuperView(self.view, withColumnsStringArrays: columnStringArrays, withDefaultIndex: self.lastWeightSelectedIndex, andSelectInRange: 2) { (selectedColumnsStringArray, selectedComponentsIndex) -> Void in
                
                self.userWeightLabel.text = "";
                for text in selectedColumnsStringArray{
                    
                    self.userWeightLabel.text! += text;
                    
                }
                self.lastWeightSelectedIndex = selectedComponentsIndex;
            }
            
            NSLog("lastWeightSelectedIndex\(lastWeightSelectedIndex.count)");

        }
//   blablabla....
