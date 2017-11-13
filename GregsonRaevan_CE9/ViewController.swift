//
//  ViewController.swift
//  GregsonRaevan_CE9
//
//  Created by Raevan Gregson on 12/14/16.
//  Copyright © 2016 Raevan Gregson. All rights reserved.
//

import UIKit
import ContactsUI
import MessageUI

private let identifier = "Cell"

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CNContactPickerDelegate, CNContactViewControllerDelegate,MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    //these are the vars I use to hold my data, including a custom class object to hold the emails and timestamps for the tableview cells
    var Timestamp = NSDate()
    var email:SentEmails?
    var contactStore:CNContactStore?
    var cellValues = [SentEmails]()
    var count = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //make sure to assign the delegate for my tableview
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //this is where I check authorizationstatus to access contacts so I can save etc
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .authorized{
            contactStore = CNContactStore()
        }
        else if status == .notDetermined{
            contactStore = CNContactStore()
            contactStore?.requestAccess(for: .contacts, completionHandler: { (granted, error) in
                if let error = error{
                    print("Request Access Failed with Error:\(error)")
                    return
                }
                if granted{
                    print("Granted Access")
                }
                else{
                    print("Denied")
                }
            })
        }else if status == .denied{
            
        }
        
        
        
    }
    
    //this function is where I setup my cells to hold the timestamps and the emails by iterarting through the array of my custom objects
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! Cell
        let value = cellValues[indexPath.row]
        cell.timeStampLabel.text = value.timeStamp
        cell.recipientsLabel.text = value.email[indexPath.row]
        return cell
        
    }
    
    //to figure out how many rows I need I count the amount of values in the array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellValues.count
    }
    
    // using the tag to figure out which button is clicked means only using one IBaction, this is where I present the specific viewcontroller distinguished by the button
    @IBAction func buttonClick(_ sender: UIBarButtonItem) {
        if sender.tag == 0{
            let picker  = CNContactPickerViewController()
            picker.delegate = self
            present(picker,animated: true,completion: nil)
        }
        else {
            let newContact = CNContactViewController(forNewContact: nil)
            newContact.delegate = self
            newContact.contactStore = contactStore
            let nav = UINavigationController(rootViewController: newContact)
            present(nav,animated: true, completion: nil)
        }
    }
    
    
    
    //MARK: - MFMailComposeViewerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error{
            print("Mail Compose Failed with error:\(error)")
        }
        //is the result of the mailcomposer view controller is sent then I assign the value of the recipient and timestamp to a custom object and then add it to the array
        if result == MFMailComposeResult.sent{
            email?.timeStamp = String(describing: Timestamp)
            cellValues.append(email!)
            email = SentEmails()
            count += 1
            tableView.reloadData()
        }
        else{
            dismiss(animated: true, completion: nil)
        }
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - CNContactPickerDelegate
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        if contactProperty.key == "emailAddresses"{
            email = SentEmails(email: [contactProperty.value as! String!])
            //if the device can send mail then the delegate is set and the recipient is set to the selected email, after which the controller is dismissed and the mailcompose is presented
            if MFMailComposeViewController.canSendMail(){
                let mailCompose = MFMailComposeViewController()
                mailCompose.mailComposeDelegate = self
                mailCompose.setToRecipients(email?.email)
                self.dismiss(animated: true, completion: {
                    self.present(mailCompose,animated: true, completion: nil)
                })
            }
        }
    }
    
    // MARK : - CNContactViewControllerDelegate
    
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

