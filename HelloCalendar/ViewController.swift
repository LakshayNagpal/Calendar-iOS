//
//  ViewController.swift
//  HelloCalendar
//
//  Created by Lakshay Nagpal on 20/07/17.
//  Copyright © 2017 Lakshay Nagpal. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController {
    let formatter = DateFormatter()
    
    let outsideMonthColor = UIColor(colorWithHexValue: 0x584a66)
    let monthColor = UIColor.white
    let selectedMonthColor = UIColor(colorWithHexValue: 0x3a294b)
    let currentDateSelected = UIColor(colorWithHexValue: 0x4e3f5d)
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    //@IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    
    var eventsfromtheserver: [String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCalendarView()
        // Do any additional setup after loading the view, typically from a nib.
        
        let serverobjects = self.getServerEvents()
        
        for (date) in serverobjects {
            let stringdate = self.formatter.string(from: date)
            self.eventsfromtheserver[stringdate] = stringdate
        }
        
        //self.calendarView.reloadData()
    }
    
    
    func setupCalendarView(){
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        calendarView.visibleDates { (visibleDates) in
            let date = visibleDates.monthDates.first!.date
            
//            self.formatter.dateFormat = "yyyy"
//            self.year.text = self.formatter.string(from: date)
            
            self.formatter.dateFormat = "MMMM"
            self.month.text = self.formatter.string(from: date)
        }

    }
    
    func handleCellSelected(cell: JTAppleCell?, cellSate: CellState){
        guard let validCell = cell as? CustomCell else { return }
        
        if validCell.isSelected {
            validCell.selectedView.isHidden = false
            //let visibledates = calendarView.visibleDates()
            //print("****\(visibledates)***")
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    func handleCellTextColor(cell: JTAppleCell?, cellSate: CellState){
        guard let validCell = cell as? CustomCell else { return }
        
        if cellSate.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
        } else {
            if cellSate.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
            } else {
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

    
    @IBAction func nextMonth(_ sender: Any) {
        calendarView.scrollToSegment(.next)
        self.calendarView.reloadData()
    }
    @IBAction func previousMonth(_ sender: Any) {
        calendarView.scrollToSegment(.previous)
        self.calendarView.reloadData()
    }
    
}


extension ViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        //let startDate = formatter.date(from: "2017 01 01")
        let endDate = formatter.date(from: "2017 12 31")
        let parameters = ConfigurationParameters(startDate: Date(), endDate: endDate!)
        return parameters
    }
    

}

extension ViewController: JTAppleCalendarViewDelegate {
    // For Displaying the cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(cell: cell, cellSate: cellState)
        handleCellTextColor(cell: cell, cellSate: cellState)
        
        cell.dotView.isHidden = !eventsfromtheserver.contains { $0.key == formatter.string(from: cellState.date)}
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(cell: cell, cellSate: cellState)
        handleCellTextColor(cell: cell, cellSate: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(cell: cell, cellSate: cellState)
        handleCellTextColor(cell: cell, cellSate: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
//        
//        formatter.dateFormat = "yyyy"
//        year.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        month.text = formatter.string(from: date)
    }
    
    
}


extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat((value & 0x0000FF)) / 255.0,
            alpha:alpha
        )
    }
}


extension ViewController{
    func getServerEvents() -> [Date] {
    
        formatter.dateFormat = "yyyy MM dd"
        
        return [
            formatter.date(from: "2017 07 23")!,
            formatter.date(from: "2017 07 25")!,
            formatter.date(from: "2017 07 27")!,
            formatter.date(from: "2017 07 28")!,
            formatter.date(from: "2017 07 30")!
        ]
    }
}
