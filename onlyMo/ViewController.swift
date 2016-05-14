//
//  ViewController.swift
//  onlyMo
//
//  Created by AI Matsubara on 2016/05/13.
//  Copyright © 2016年 AI Matsubara. All rights reserved.
//

import UIKit
import AssetsLibrary


class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var feelingField: UITextField!
    @IBOutlet weak var commentField: UITextView!
    @IBOutlet weak var addNewBtn: UIButton!

    let nowDate = NSDate()
    let dateFormat = NSDateFormatter()
    let inputDatePicker = UIDatePicker()
    
    //絵文字選択
    var data = ["💖", "😭", "😡","👻","👍"]
    var picker = UIPickerView()
    
    var movieList =
        [["title":"タイタニック","date":"2016-05-15","star":"5","stamp":"💖","comment":"love!"]]
    


    override func viewDidLoad() {
        super.viewDidLoad()
        //ユーザーデフォルトに保存
        var myDefault = NSUserDefaults.standardUserDefaults()
        if (myDefault.objectForKey("movieList") != nil){
            movieList = myDefault.objectForKey("movieList") as! [Dictionary]
        }
        print(movieList)

        
        //キーボード閉じる
        titleTextField.delegate = self
        commentField.delegate = self
        
        //テキストビューの完了ボタン
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.Default
        kbToolBar.sizeToFit()
        commentField.layer.borderWidth = 0.5
        commentField.layer.borderColor = UIColor.lightGrayColor().CGColor
        commentField.layer.cornerRadius = 8
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "commitButtonTapped")
        kbToolBar.items = [spacer, commitButton]
        commentField.inputAccessoryView = kbToolBar
        
        //日付フィールドの設定
        dateFormat.dateFormat = "yyyy/MM/dd"
        dateTextField.text = dateFormat.stringFromDate(nowDate)
        self.dateTextField.delegate = self
        
        
        // DatePickerの設定(日付用)
        inputDatePicker.datePickerMode = UIDatePickerMode.Date
        dateTextField.inputView = inputDatePicker
        
        // キーボードに表示するツールバーの表示
        let pickerToolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        pickerToolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        pickerToolBar.barStyle = .BlackTranslucent
        pickerToolBar.tintColor = UIColor.whiteColor()
        pickerToolBar.backgroundColor = UIColor.blackColor()
        
        //ボタンの設定
        //右寄せのためのスペース設定
        let spaceBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace,target: self,action: "")
        
        //日付選択の完了ボタン
        let toolBarBtn      = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "toolBarBtnPush:")
        
        //ツールバーにボタンを表示
        pickerToolBar.items = [spaceBarBtn,toolBarBtn]
        dateTextField.inputAccessoryView = pickerToolBar
        
        
        //フィーリング絵文字選択
        picker.delegate = self
        picker.dataSource = self
        feelingField.inputView = picker
        
        let feelingToolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        feelingToolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        feelingToolBar.barStyle = .BlackTranslucent
        feelingToolBar.tintColor = UIColor.whiteColor()
        feelingToolBar.backgroundColor = UIColor.blackColor()
        
        //ボタンの設定
        //右寄せのためのスペース設定
        let spaceBarBtn2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace,target: self,action: "")
        
        //絵文字選択の完了ボタン
        let feelingToolBarBtn = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "toolBarBtnPush:")
        
        feelingToolBar.items = [spaceBarBtn,feelingToolBarBtn]
        feelingField.inputAccessoryView = feelingToolBar

    }
    
    
    @IBAction func tapAddBtn(sender: AnyObject) {
        movieList.append(["title":titleTextField.text!,"date":dateTextField.text!,"stamp":feelingField.text!,"comment":commentField.text!])
        
        print(movieList)
        
        var myDefault = NSUserDefaults.standardUserDefaults()
        myDefault.setObject(movieList, forKey: "movieList")
        myDefault.synchronize()
    }
    
    //絵文字選択
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        feelingField.text = data[row]
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return data[row]
    }
    
    //タイトル入力完了リターン
    func commitButtonTapped (){
        self.view.endEditing(true)
    }
    
    //コメント入力完了ボタン
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //完了を押すとピッカーの値を、テキストフィールドに挿入して、ピッカーを閉じる
    func toolBarBtnPush(sender: UIBarButtonItem){
        var pickerDate = inputDatePicker.date
        dateTextField.text = dateFormat.stringFromDate(pickerDate)
        self.view.endEditing(true)
    }
    
    




    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

