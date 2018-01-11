//
//  LoginViewController.swift
//  Dentist
//
//  Created by 申潤五 on 2017/5/5.
//  Copyright © 2017年 申潤五. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import Security
//import CryptoSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var accountTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var accountTitle: UILabel!
    @IBOutlet weak var passwordTitle: UILabel!
    @IBOutlet weak var loginBut: UIButton!
    @IBOutlet weak var addAccountBut: UIButton!
    @IBOutlet weak var forgetPasswordBut: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        accountTitle.text = NSLocalizedString("acconut", comment: "")
        passwordTitle.text = NSLocalizedString("passwordTitle", comment: "")
        loginBut.setTitle(NSLocalizedString("login", comment: ""), for: .normal)
        addAccountBut.setTitle(NSLocalizedString("newAccount", comment: ""), for: .normal)
        forgetPasswordBut.setTitle(NSLocalizedString("forgetPW", comment: ""), for: .normal)
    }

    @IBAction func loginAction(_ sender: UIButton) {
        
        
        guard let account = accountTF.text else {return}
        guard let password = passwordTF.text else {return}
        
        //檢查輸入字串
        if account == "" {
            showAlert(message:NSLocalizedString("accountNoEmpty", comment: ""))
            return
        }
        
        if (password.characters.count < 6  || password.characters.count > 8 ) {
            showAlert(message: NSLocalizedString("passwordError001Len", comment:""))
            return
        }
        
        showWaiting()
        
        //打API
        let urlString = apiURL()+"api/PatientData/LoginPatient"
    
        let parameters:Parameters = [
            "Header":[
                "Version":apiVer(),
                "CompanyId":apiCompanyId(),
                "ActionMode":"LoginPatient"
            ],
            "Data":[
                "Account":account,
                "PatientPin":sha256(string: password)//  (password.SHA256()?.uppercased() ?? "")
            ]
        ]
        callAPI(urlString: urlString, parameters: parameters)
    }
    
    func callAPI(urlString:String, parameters:Parameters){
        showWaiting()

        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 10

        manager.request(urlString , method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(contentType: ["application/json"])
            .responseJSON { (response) in
                if response.error?.localizedDescription != nil{
                    self.showAlert(message: response.error!.localizedDescription)
                    self.stopWaiting()
                    return
                }
                guard let data = response.data else {return}
                print(data)



                let json = try! JSONSerialization.jsonObject(with: data, options: [])
                if let resp = json as? [String:Any]{
                    if let header = resp["Header"] as? [String:String]{
                        print(header["StatusCode"]! == "0000")
                        if header["StatusCode"]! == "0000" {
                            if let resData = resp["Data"] as? [String:String?]{
                                let userDefault = UserDefaults.standard
                                userDefault.setValue(true, forKey: "SuccessLogin")
                                print("==============")
                                print(resData)
                                print("==============")
                                if let birthday = resData["Birthday"],
                                    let patientName = resData["PatientName"],
                                    let account = resData["Account"],
                                    let pin = resData["PatientPin"],
                                    let snID = resData["PatientSN"],
                                    let gender = resData["Gender"]{
                                    userDefault.setValue(birthday!, forKey: "Birthday")
                                    userDefault.setValue(patientName!, forKey: "PatientName")
                                    userDefault.setValue(account!, forKey: "Account")
                                    userDefault.setValue(pin!, forKey: "PatientPin")
                                    userDefault.setValue(snID!, forKey: "PatientSN")
                                    userDefault.setValue(gender!, forKey: "Gender")
                                    if let email = resData["PatientEmail"]{
                                        userDefault.setValue(email!, forKey: "PatientEmail")
                                    }
                                    if let mobile = resData["PatientMobile"]{
                                        userDefault.setValue(mobile!, forKey: "PatietMobile")
                                    }
                                }
                            }

                        }else{
                            print("Error:\(header["StatusDesc"]!) Status Code:\(header["StatusCode"]!)")
                            self.showAlert(message: "Error:\(header["StatusDesc"]!) Status Code:\(header["StatusCode"]!)")
                        }
                        
                    }
                }
                self.stopWaiting()
        }

    }
}
