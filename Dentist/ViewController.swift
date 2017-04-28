//
//  ViewController.swift
//  Dentist
//
//  Created by 申潤五 on 2017/4/28.
//  Copyright © 2017年 申潤五. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button01: UIButton!
    @IBOutlet weak var button02: UIButton!
    @IBOutlet weak var button03: UIButton!
    @IBOutlet weak var button04: UIButton!
    @IBOutlet weak var newReservationBut: UIButton!
    @IBOutlet weak var myReservationBut: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = NSLocalizedString("title", comment: "")
        button01.setTitle(NSLocalizedString("tab1", comment: ""), for: .normal)
        button02.setTitle(NSLocalizedString("tab2", comment: ""), for: .normal)
        button03.setTitle(NSLocalizedString("tab3", comment: ""), for: .normal)
        button04.setTitle(NSLocalizedString("tab4", comment: ""), for: .normal)
        newReservationBut.setTitle(NSLocalizedString("newReservation", comment: ""), for: .normal)
        myReservationBut.setTitle(NSLocalizedString("myReservation", comment: ""), for: .normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func touchNewReservation(_ sender: UIButton) {
        performSegue(withIdentifier: "newReservation", sender: nil)
    }

}

