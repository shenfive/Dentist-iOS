//
//  NewResrvationViewController.swift
//  Dentist
//
//  Created by 申潤五 on 2017/4/28.
//  Copyright © 2017年 申潤五. All rights reserved.
//

import UIKit
import JTAppleCalendar

class NewResrvationViewController: UIViewController {
    let formater = DateFormatter();
    let formater2 = DateFormatter();
    let formater3 = DateFormatter();


    override func viewDidLoad() {
        super.viewDidLoad()
        formater3.dateFormat = "MMMM"
//        monthLabel.text = formater3.string(from: Date())

    }

}

extension NewResrvationViewController:JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource{
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {

    }

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formater.dateFormat = "yyyy MM dd"
        let startDate = Date() //formater.date(from: "2017 01 01")!
        let endDate = formater.date(from: "2019 12 31")!
        
        
        let parameter = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameter
    }
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "customCell", for: indexPath) as! CostomCell
        cell.dateLabel.text = cellState.text
        let s1 = formater.string(from: Date())
        let s2 = formater.string(from: date)

        if s1 == s2 {
            cell.layer.backgroundColor = UIColor.yellow.cgColor
        }else{
            cell.layer.backgroundColor = UIColor.lightGray.cgColor
        }

        formater2.dateFormat = "E"
        if formater2.string(from: date) == "Sun" || formater2.string(from: date) == "Sat" {
            cell.dateLabel.textColor = UIColor.red
        }else{
            cell.dateLabel.textColor = UIColor.black
        }

        if cellState.dateBelongsTo != .thisMonth {
            cell.dateLabel.textColor = UIColor.darkGray
            cell.dateLabel.backgroundColor = UIColor.lightGray
        }
        cell.layer.cornerRadius = cell.frame.height / 2


        return cell
    }
    

    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
//        monthLabel.text = formater3.string(from: visibleDates.monthDates[0].date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let theCell = cell as? CostomCell else {return}
        theCell.backgroundColor = UIColor.white
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
    }


}
