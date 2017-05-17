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
import CryptoSwift

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
        let parameters: Parameters = [
            "Header":[
                "Version":apiVer(),
                "CompanyId":apiCompanyId(),
                "ActionMode":"LoginPatient"
            ],
            "Data":[
                "Account":account,
                "PatientPin":password.sha256().uppercased()
            ]
        ]
        callAPI(urlString: urlString, parameters: parameters)
    }
    
    
    func callAPI(urlString:String, parameters:Parameters){
        Alamofire.request(urlString , method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(contentType: ["application/json"])
            .responseJSON { (response) in
                guard let data = response.data else {return}
                print(data)
                print(response)
                let json = try! JSONSerialization.jsonObject(with: data, options: [])
                if let resp = json as? [String:Any]{
                    if let header = resp["Header"] as? [String:String]{
                        print(header["StatusCode"]! == "0000")
                        if header["StatusCode"]! == "0000" {
                            if let resData = resp["Data"] as? [String:String?]{
                                print(resData)
                            }
                            
                        }else{
                            print("Error:\(header["StatusDesc"]!) Status Code:\(header["StatusCode"]!)")
                            self.showAlert(message: "Error:\(header["StatusDesc"]!) Status Code:\(header["StatusCode"]!)")
                        }
                        
                    }
                }
                
        }
        stopWaiting()
    
    
    }
    
    
    
}
