//
//  ViewController.swift
//  SpacePhoto
//
//  Created by Олег Алексеев on 22.05.2023.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var todayDateLabel: UILabel!
    
    // MARK: - Instances
    
    let photoInfoController = PhotoInfoController()
    var todayDate: Date = Date()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todayDateLabel.text = dateFormatter.formatDate(from: todayDate, for: .ui)
        
        titleLabel.text = ""
        imageView.image = UIImage(systemName: "photo.on.rectangle")
        descriptionLabel.text = ""
        copyrightLabel.text = ""
        
        fetchData()
    }
    
    func fetchData() {
        Task {
            do {
                let date = dateFormatter.formatDate(from: todayDate, for: .api)
                let photoInfo = try await photoInfoController.fetchPhotoInfo(fromDate: date)
                updateUI(with: photoInfo)
            } catch {
                updateUI(with: error)
            }
        }
    }
    
    func updateUI(with photoInfo: PhotoInfo) {
        Task {
            do {
                let image = try await photoInfoController.fetchImage(from: photoInfo.url)
                todayDateLabel.text = dateFormatter.formatDate(from: todayDate, for: .ui)
                titleLabel.text = photoInfo.title
                imageView.image = image
                descriptionLabel.text = photoInfo.description
                copyrightLabel.text = photoInfo.copyright
            } catch {
                updateUI(with: error)
            }
        }
    }
    
    func updateUI(with error: Error) {
        titleLabel.text = "Error Fetching Photo"
        imageView.image = UIImage(systemName: "exclamationmark.octagon")
        descriptionLabel.text = error.localizedDescription
        copyrightLabel.text = ""
    }
    
    private func configureSheet() {
        guard let bottomSheetVC = storyboard?.instantiateViewController(identifier: "bottomSheet") as? BottomSheetViewController else {
            return
        }
        
        bottomSheetVC.delegate = self
        bottomSheetVC.currentDate = todayDate
        
        
        if let sheet = bottomSheetVC.sheetPresentationController {
            sheet.preferredCornerRadius = 25
            sheet.detents = [.custom(resolver: { context in
                1.25 * bottomSheetVC.stackView.frame.height
            })]
        }
        
        present(bottomSheetVC, animated: true)
    }
    
    @IBAction func selectDateButtonTapped(_ sender: UIButton) {
        configureSheet()
    }
    
    @IBAction func unwindFromBottomSheet(unwindSegue: UIStoryboardSegue) {
        guard let bottomSheetViewController = unwindSegue.source as? BottomSheetViewController,
              let changedDate = bottomSheetViewController.searchedDateDatePicker else { return }
        
        todayDate = changedDate.date
        
        fetchData()
    }
}

extension ViewController: BottomSheetViewControllerDelegate {
    func bottomSheetViewController(_ controller: BottomSheetViewController, currentDate date: Date) {
        self.todayDate = date
    }
}

extension DateFormatter {
    func formatDate(from date: Date, for format: DateFormats) -> String {
        switch format {
        case .ui:
            self.dateFormat = "dd/MM/YYYY"
        case .api:
            self.dateFormat = "YYYY-MM-dd"
        }
        return self.string(from: date)
    }
}

enum DateFormats {
    case ui
    case api
}
