//
//  ViewController.swift
//  Dentist
//
//  Created by 申潤五 on 2017/4/28.
//  Copyright © 2017年 申潤五. All rights reserved.
//

import UIKit
//import CryptoSwift

class ViewController: UIViewController {

    @IBOutlet weak var button01: UIButton!
    @IBOutlet weak var button02: UIButton!
    @IBOutlet weak var button03: UIButton!
    @IBOutlet weak var button04: UIButton!
    @IBOutlet weak var newReservationBut: UIButton!
    @IBOutlet weak var myReservationBut: UIButton!
    @IBOutlet weak var loginBut: UIButton!
    
    @IBOutlet weak var newReservatingTitle: UILabel!
    @IBOutlet weak var myReservationTitle: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(NSLocalizedString("tab1", comment: ""))
        self.title = NSLocalizedString("title", comment: "")
        button01.setTitle(NSLocalizedString("tab1", comment: ""), for: .normal)
        button02.setTitle(NSLocalizedString("tab2", comment: ""), for: .normal)
        button03.setTitle(NSLocalizedString("tab3", comment: ""), for: .normal)
        button04.setTitle(NSLocalizedString("tab4", comment: ""), for: .normal)
        newReservatingTitle.text = NSLocalizedString("newReservation", comment: "")
        myReservationTitle.text = NSLocalizedString("myReservation", comment: "")

//        newReservationBut.setTitle(NSLocalizedString("newReservation", comment: ""), for: .normal)
//        myReservationBut.setTitle(NSLocalizedString("myReservation", comment: ""), for: .normal)
//        loginBut.setTitle(NSLocalizedString("login", comment:""), for: .normal)
        loginBut.setTitle("", for: .normal)
        if UserDefaults.standard.bool(forKey: "SuccessLogin") == true {
            print(UserDefaults.standard.string(forKey: "PatientName"))
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func touchNewReservation(_ sender: UIButton) {
        performSegue(withIdentifier: "newReservation", sender: nil)
    }
}

extension UIViewController{
    func sha256(data : Data) -> Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0, CC_LONG(data.count), &hash)
        }
        print(hash)
        return Data(bytes: hash)
    }
    func sha256(string:String) -> String{
        let data = sha256(data: string.data(using: String.Encoding.utf8)!)
        let hex = data.map{ String(format:"%02hhx",$0)}.joined().uppercased()
        print("hell:\(hex)xx")
        return hex
    }

    func hexColorToUIColor(hexColorString:String) -> UIColor {
        //若空白就回透明
        if hexColorString == ""{
            return UIColor.clear
        }
        var red:CGFloat = 0.0
        var green:CGFloat = 0.0
        var blue:CGFloat = 0.0
        var theAlpha:CGFloat = 0.0

        if let redDec = Int((hexColorString as NSString).substring(with: NSMakeRange(1, 2)), radix:16),
            let greenDec = Int((hexColorString as NSString).substring(with: NSMakeRange(3, 2)), radix:16),
            let blueDec = Int((hexColorString as NSString).substring(with: NSMakeRange(5, 2)), radix:16)
        {

            red = CGFloat(redDec) / 255
            green = CGFloat(greenDec) / 255
            blue = CGFloat(blueDec) / 255
            theAlpha = 1
        }

        return UIColor(red: red, green: green, blue: blue, alpha: theAlpha)
    }

}


extension UIViewController{

    //URL 位置
    func apiURL() -> String {
        return "http://220.135.157.238:1113/"
    }

    //公司 ID
    func apiCompanyId() -> String {
        return "4881017701"
    }

    //API 版本
    func apiVer() -> String {
        return "1.0"
    }

    //顯示訊息
    func showAlert(message:String)  {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "我知道了", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true,completion: nil)
    }

    //檢查是否為 email 格式
    func checkIfEmailFormat(mail:String) -> Bool {
        var returnValue = false
        let mailPattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        let mailRegular = try! NSRegularExpression(pattern: mailPattern, options: .caseInsensitive)
        let results = mailRegular.matches(in: mail, options: [], range:  NSMakeRange(0, (mail as NSString).length))
        if results.count > 0 {
            returnValue = true
        }
        return returnValue
    }

    //顯示等待服務（轉圈圈）
    func showWaiting(){
        let caverView = UIView()
        caverView.frame = self.view.frame
        caverView.backgroundColor = UIColor.white
        caverView.alpha = 0.5
        caverView.tag = 10001

        let waitingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        waitingView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        waitingView.center = self.view.center
        waitingView.startAnimating()
        caverView.addSubview(waitingView)
        self.view.addSubview(caverView)
    }

    //取消等待服務（取消轉圈圈）
    func stopWaiting(){
        for  view in self.view.subviews{
            if (view.tag == 10001){
                view.removeFromSuperview()
            }
        }
    }
}



