//
//  BottomSheetViewController.swift
//  SpacePhoto
//
//  Created by Олег Алексеев on 23.05.2023.
//

import UIKit

protocol BottomSheetViewControllerDelegate: AnyObject {
    func bottomSheetViewController(_ controller: BottomSheetViewController, currentDate date: Date)
}

class BottomSheetViewController: UIViewController {
    
    weak var delegate: BottomSheetViewControllerDelegate?
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var searchedDateDatePicker: UIDatePicker!
    
    var currentDate: Date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchedDateDatePicker.maximumDate = Date()
        updateDatePicker()
    }
    
    func updateDatePicker() {
        let currentDate = currentDate
        self.searchedDateDatePicker.date = currentDate
        delegate?.bottomSheetViewController(self, currentDate: currentDate)
    }

}
