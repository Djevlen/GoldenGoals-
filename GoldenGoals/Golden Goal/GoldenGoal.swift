//
//  GoldenGoal.swift
//  GoldenGoals
//
//  Created by Thomas Andre Johansen on 17/02/2018.
//  Copyright © 2018 Appbryggeriet. All rights reserved.
//

import UIKit
import CoreData


class GoldenGoal: UIViewController {
    
    @IBOutlet weak var dateStart: UILabel!
    @IBOutlet weak var dateEnd: UILabel!
    @IBOutlet weak var progressBarDates: UIProgressView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var motivationalText: UITextView!
    
    var showGoal: Goal?
    let calendar = NSCalendar.current
    let dateFormatter = ISO8601DateFormatter() // YYYY-MM-DD
    
    //shows the tool bar and goes into edit mode
    @IBAction func editButtonSelected(_ sender: UIBarButtonItem) {
        setEditing(!self.navigationController!.isToolbarHidden, animated: true)
        self.isEditing = true
        self.navigationController?.setToolbarHidden(!self.navigationController!.isToolbarHidden, animated: true)
    }
    
    //TODO: This needs to work. probably change uibarbutton and remake it so this method works
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing,animated:animated)
        print("i setEditing: \(editing)")
    }
    
    fileprivate func populate(_ goal: Goal) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        self.navigationItem.title = goal.title
        dateStart.text = dateFormatter.string(from: goal.dateStart!)
        dateEnd.text = dateFormatter.string(from: goal.dateEnd!)
        self.motivationalText.text = goal.motivationalText
        if let goalPhoto = goal.photo{
            imageView.image = UIImage(data: goalPhoto)
        }else{
            print("Image was nil, setting placeholder")
            imageView.image = #imageLiteral(resourceName: "goalPlaceholder")
        }
        progressBarDates.setProgress(calculateProgress(fromDate: goal.dateStart!, toDate: goal.dateEnd!), animated: true)
        if goal.golden{
            progressBarDates.progressTintColor = .yellow
            imageView.layer.borderColor = progressBarDates.progressTintColor?.cgColor // UIColor.red.cgColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        scrollView.backgroundColor = Theme.backgroundColor!
        scrollView.tintColor = Theme.tintColor!
        
        imageView.layer.cornerRadius = 10 //imageView.frame.size.width / 20 //20 for rectangle
        imageView.layer.borderWidth = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //if goal is not nil, this class was called from the goalListView
        //and we can populate the view with info about the goal
        if let goal = showGoal {
            populate(goal)
        } else{
            let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "golden == true")
            do {
                let results = try CoreDataService.context.fetch(fetchRequest)
                if let goldenGoal = results.first{
                    populate(goldenGoal)
                }else{
                    print("NO GOLDEN GOAL FOUND INSERT PLACEHOLDER STUFF")
                }
            }catch{
                print("Trying to fetch Golden Goal failed in GoldenGoal.swift")
            }
        }
    }
    
    
    // calculates the progress between two dates
    // used by the progressbar to show how far along a goal is
    func calculateProgress(fromDate: Date, toDate: Date) -> Float{
        let startDate = calendar.startOfDay(for: fromDate)
        let endDate = calendar.startOfDay(for: toDate)
        
        let totalNumberOfDays = calendar.dateComponents([.day], from: startDate, to: endDate)
        let daysToCompletion  = calendar.dateComponents([.day], from: calendar.startOfDay(for: Date()), to: toDate)
        
        print("totalNumberOfDays: \(totalNumberOfDays) daysToCompletion: \(daysToCompletion)")
        print("daysToCompletion delt på totalNumberofDays: \((Float(totalNumberOfDays.day!-daysToCompletion.day!)/Float(totalNumberOfDays.day!))*100)")
        if (Float(daysToCompletion.day!)/Float(totalNumberOfDays.day!)) == 0{
            return 1
        }else if daysToCompletion.day! >= totalNumberOfDays.day! {
            return 0
        }else {
            return (Float(totalNumberOfDays.day!-daysToCompletion.day!)/Float(totalNumberOfDays.day!))*100
        }
    }
    
    // calculates how many days are left of the goal
    func calculateDaysTo(dueDate: Date) -> Int{
        return calendar.dateComponents([.day], from: calendar.startOfDay(for: Date()), to: dueDate).day!
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
}

extension GoldenGoal: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}
