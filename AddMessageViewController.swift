//
//  AddMessageViewController.swift
//  SlapChat
//
//  Created by Mirim An on 11/10/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import CoreData

class AddMessageViewController: UIViewController {
    
    let store = DataStore.sharedInstance
    
    @IBOutlet weak var textField: UITextField!

    @IBAction func saveButtonTapped(_ sender: Any) {
        var typedString: String = ""
        if let text = textField.text {
            typedString = text
        }
        
        let context = store.persistentContainer.viewContext
        let newMessage = Message(context: context)
        newMessage.content = typedString
        newMessage.createdAt  = NSDate()
        store.saveContext()
        store.fetchData()
        dismiss(animated: true, completion: nil)
    }
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
