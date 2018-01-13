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

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.layer.borderColor = UIColor.black.cgColor
        calendarView.layer.cornerRadius = 10
        calendarView.layer.borderWidth = 1
        formater3.dateFormat = "MMMM"
        monthLabel.text = formater3.string(from: Date())
        calendarView.minimumLineSpacing = 4
        calendarView.minimumInteritemSpacing = 6
        print("Minspace\(calendarView.minimumLineSpacing)")

    }

}

extension NewResrvationViewController:JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource{
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {

    }

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formater.dateFormat = "yyyy MM dd"

//        let cal = Calendar.current
        let startDate = Date() //formater.date(from: "2017 01 01")!

        let endDate = startDate.addingTimeInterval(31*24*60*60)
//        let parameter = ConfigurationParameters(startDate: startDate, endDate: endDate)
        let parameter = ConfigurationParameters(startDate: startDate,
                                                endDate: endDate,
                                                numberOfRows: 5,
                                                calendar: Calendar.current,
                                                generateInDates: nil,
                                                generateOutDates: nil,
                                                firstDayOfWeek: DaysOfWeek.sunday,
                                                hasStrictBoundaries: true)
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
            cell.layer.backgroundColor = UIColor.clear.cgColor
        }

        formater2.dateFormat = "E"
        formater2.locale = Locale(identifier: "en_US")
        if formater2.string(from: date) == "Sun" || formater2.string(from: date) == "Sat" {
            cell.dateLabel.textColor = UIColor.red
        }else{
            cell.dateLabel.textColor = hexColorToUIColor(hexColorString: "#449a9e")
        }

        if cellState.dateBelongsTo != .thisMonth {
            cell.dateLabel.textColor = hexColorToUIColor(hexColorString: "#c6c8c8")
        }
        cell.layer.cornerRadius = cell.frame.height / 2


        return cell
    }
    

    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        monthLabel.text = formater3.string(from: visibleDates.monthDates[0].date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let theCell = cell as? CostomCell else {return}
        print(theCell.dateLabel.text)
        theCell.layer.backgroundColor = UIColor.white.cgColor
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
    }


}
