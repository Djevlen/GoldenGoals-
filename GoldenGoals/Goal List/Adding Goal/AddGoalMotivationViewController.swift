//
//  AddGoalMotivationViewController.swift
//  GoldenGoals
//
//  Created by Thomas Andre Johansen on 01/07/2018.
//  Copyright © 2018 Appbryggeriet. All rights reserved.
//

import UIKit

class AddGoalMotivationViewController: UIViewController {
    
    var goal = Goal()

    @IBOutlet weak var motivationImage: UIImageView!
    @IBOutlet weak var motivationalText: UITextView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddGoalMotivationViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        goal.motivationalText = textView.text
    }
}