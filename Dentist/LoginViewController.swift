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

class LoginViewController: UIViewController {

    @IBOutlet weak var accountTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func loginAction(_ sender: UIButton) {
        
        let urlString = "http://220.135.157.238:1113/api/PatientData/LoginPatient"
        guard let account = accountTF.text else {return}
        guard let password = passwordTF.text else {return}
        let parameters: Parameters = [
            "Header":[
                "Version":"1.0",
                "CompanyId":"4881017701",
                "ActionMode":"LoginPatient"
            ],
            "Data":[
                "Account":account,
                "PatientPin":password
            ]
        ]
        
        Alamofire.request(urlString , method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(contentType: ["application/json"])
            .responseJSON { (response) in
                guard let data = response.data else {return}
                
                print(data)
                print(response)
                let json = try! JSONSerialization.jsonObject(with: data, options: [])
//                print(json)
                if let resp = json as? [String:Any]{
//                    print(resp)
                    if let header = resp["Header"] as? [String:String]{
                        print(header["StatusCode"]! == "0000")
                        if header["StatusCode"]! == "0000" {
                            if let resData = resp["Data"] as? [String:String?]{
                                print(resData)
                            }
                        
                        }else{
                            print("Error:\(header["StatusDesc"]!) Status Code:\(header["StatusCode"]!)")
                        }
                
                    }
                }
                
                
                
                
               
              
        }
    
        
                


      
        
        
    }
}
