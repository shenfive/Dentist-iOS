//
//  AddPatientViewController.swift
//  Dentist
//
//  Created by 申潤五 on 2017/5/18.
//  Copyright © 2017年 申潤五. All rights reserved.
//

import UIKit
import Alamofire

class AddPatientViewController: UIViewController {

    @IBOutlet weak var accountTitle: UILabel!
    @IBOutlet weak var nIDTitle: UILabel!
    @IBOutlet weak var passwordTitle: UILabel!
    @IBOutlet weak var rePasswordTitle: UILabel!
    @IBOutlet weak var telephoneTitle: UILabel!
    @IBOutlet weak var emailTitle: UILabel!
    @IBOutlet weak var genderTitle: UILabel!
    @IBOutlet weak var birthdayTitle: UILabel!
    @IBOutlet weak var submit: UIButton!
    
    
    
    @IBOutlet weak var accountTF: UITextField!
    @IBOutlet weak var nIDTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var rePasswordTF: UITextField!
    @IBOutlet weak var telephoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var genderSC: UISegmentedControl!
    @IBOutlet weak var birthdayDP: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountTitle.text = NSLocalizedString("account", comment: "")
        nIDTitle.text = NSLocalizedString("loginAccountTitle", comment: "")
        passwordTitle.text = NSLocalizedString("passwordTitle", comment: "")
        rePasswordTitle.text = NSLocalizedString("rePassword", comment: "")
        telephoneTitle.text = NSLocalizedString("telephoneNum", comment: "")
        emailTitle.text = NSLocalizedString("emailTitle", comment: "")
        genderTitle.text = NSLocalizedString("gender", comment: "")
        birthdayTitle.text = NSLocalizedString("birthday", comment: "")
        submit.setTitle(NSLocalizedString("submit", comment: ""), for: .normal)
        genderSC.setTitle(NSLocalizedString("male", comment: ""), forSegmentAt: 0)
        genderSC.setTitle(NSLocalizedString("female", comment: ""), forSegmentAt: 1)
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        birthdayDP.maximumDate = formater.date(from: "2016-12-31")
        
        
        

        // Do any additional setup after loading the view.
    }
    
    


    @IBAction func submitAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        guard let account = accountTF.text else {return}
        guard let nID = nIDTF.text?.uppercased() else {return}
        guard let password = passwordTF.text else {return}
        guard let rePassword = rePasswordTF.text else {return}
        guard let telePhone = telephoneTF.text else {return}
        guard let email = emailTF.text else {return}
        var gender = "M"
        if genderSC.selectedSegmentIndex == 1 { gender = "F" }
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        let date = formater.string(from: birthdayDP.date)
        
        if account == "" {
            showAlert(message:NSLocalizedString("accountNoEmpty", comment: ""))
            return
        }
        
        
        //MARK:檢查身份證格式
        
        
        if (password.characters.count < 6  || password.characters.count > 8 ) {
            showAlert(message: NSLocalizedString("passwordError001Len", comment:""))
            return
        }
        
        if ( password != rePassword ){
            showAlert(message: NSLocalizedString("passwordError003dif", comment: ""))
            return
        }
        
        if (telePhone.characters.count < 10 ){
            showAlert(message: NSLocalizedString("phoneTooShort", comment: ""))
            return
        }
        
        
        
        if (!checkIfEmailFormat(mail: email)){
            showAlert(message: NSLocalizedString("Email formate Error", comment: ""))
            return
        }
        
        
        
        
        let urlString = apiURL()+"api/PatientData/LoginPatient"
        let parameters: Parameters = [
            "Header":[
                "Version":apiVer(),
                "CompanyId":apiCompanyId(),
                "ActionMode":"LoginPatient"
            ],
            "Data":[
                
            ]
        ]
        callAPI(urlString: urlString, parameters: parameters)
    }

    @IBAction func selectGender(_ sender: UISegmentedControl) {
        self.view.endEditing(true)
    }
    @IBAction func touchBirthday(_ sender: UIDatePicker) {
        self.view.endEditing(true)

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
