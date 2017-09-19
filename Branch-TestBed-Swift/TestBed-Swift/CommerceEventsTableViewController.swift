//
//  CommerceEventsTableViewController.swift
//  TestBed-Swift
//
//  Created by David Westgate on 9/16/17.
//  Copyright © 2017 Branch Metrics. All rights reserved.
//

import UIKit

class CommerceEventsTableViewController: UITableViewController {

    @IBOutlet weak var commerceEventDetailsLabel: UILabel!
    @IBOutlet weak var commerceEventCustomMetadataTextView: UITextView!
    @IBOutlet weak var sendCommerceEventButton: UIButton!
    
    var commerceEventCustomMetadata = [String: AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch((indexPath as NSIndexPath).section, (indexPath as NSIndexPath).row) {
        case (0,0) :
            self.performSegue(withIdentifier: "CommerceEventsTableViewToCommerceEventDetailsTableView", sender: "CommerceEventDetails")
        case (0,1) :
            self.performSegue(withIdentifier: "CommerceEventsTableViewToDictionaryTableView", sender: "CommerceEventCustomMetadata")
        default : break
        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
        case "CommerceEventsTableViewToDictionaryTableView":
            let vc = segue.destination as! DictionaryTableViewController
            commerceEventCustomMetadata = CommerceEventsData.getCommerceEventCustomMetadata()
            vc.dictionary = commerceEventCustomMetadata
            vc.viewTitle = "Commerce Metadata"
            vc.keyHeader = "Key"
            vc.keyPlaceholder = "key"
            vc.keyFooter = ""
            vc.valueHeader = "Value"
            vc.valueFooter = ""
            vc.keyKeyboardType = UIKeyboardType.default
            vc.valueKeyboardType = UIKeyboardType.default
            vc.sender = sender as! String
        default:
            break
        }
    }
    
    @IBAction func unwindTextViewFormTableViewController(_ segue:UIStoryboardSegue) {
        
//        if let vc = segue.source as? TextViewFormTableViewController {
//            
//        }
    }
    
    
    @IBAction func unwindDictionaryTableViewController(_ segue:UIStoryboardSegue) {
        if let vc = segue.source as? DictionaryTableViewController {
            
            if vc.sender == "CommerceEventCustomMetadata" {
                commerceEventCustomMetadata = vc.dictionary
                CommerceEventsData.setCommerceEventCustomMetadata(commerceEventCustomMetadata)
                if commerceEventCustomMetadata.count > 0 {
                    commerceEventCustomMetadataTextView.text = commerceEventCustomMetadata.description
                } else {
                    commerceEventCustomMetadataTextView.text = ""
                }
            }
        }
    }
    
    @IBAction func unwindByCancelling(_ segue:UIStoryboardSegue) { }
    
    @IBAction func sendCommerceEvent(_ sender: AnyObject) {
        
        let commerceEvent = CommerceEventsData.getBNCCommerceEvent()
        
        WaitingViewController.showWithMessage(
            message: "Getting parameters...",
            activityIndicator:true,
            disableTouches:true
        )
        
        Branch.getInstance()?.send(
            commerceEvent,
            metadata: commerceEventCustomMetadata,
            withCompletion: { (response, error) in
                let errorMessage: String = (error?.localizedDescription != nil) ?
                    error!.localizedDescription : "<nil>"
                let responseMessage  = (response?.description != nil) ?
                    response!.description : "<nil>"
                let message = String.init(
                    format:"Commerce event completion called.\nError: %@\nResponse:\n%@",
                    errorMessage,
                    responseMessage
                )
                NSLog("%@", message)
                WaitingViewController.hide()
                self.showAlert("Commerce Event", withDescription: message)
        }
        )
    }
    
    func refreshControlValues() {
        commerceEventCustomMetadata = CommerceEventsData.getCommerceEventCustomMetadata()
        if (commerceEventCustomMetadata.count > 0) {
            commerceEventCustomMetadataTextView.text = commerceEventCustomMetadata.description
        } else {
            commerceEventCustomMetadataTextView.text = ""
        }
    }
    
    func showAlert(_ alertTitle: String, withDescription message: String) {
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

}
