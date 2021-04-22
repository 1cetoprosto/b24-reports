//
//  CallsTableViewController.swift
//  b24-reports
//
//  Created by leomac on 09.04.2021.
//

import UIKit
import FirebaseAuth

class CallsTableViewController: UITableViewController {

    var handle: AuthStateDidChangeListenerHandle?
    
    @IBAction func logoutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // [START add_auth_listener]
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil {
                self.transitionToLogin()
            } else {
                
            }
        }
        // [END add_auth_listener]
        sortCall(items: callItems)
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.saveContext()
        super.viewWillDisappear(animated)
            // [START remove_auth_listener]
            Auth.auth().removeStateDidChangeListener(handle!)
            // [END remove_auth_listener]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Setup the Cell
        let nib = UINib(nibName: "CallsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CallsTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.backgroundColor = UIColor(red: 50, green: 50, blue: 50, alpha: 1)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return events.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = events[section].first!.date
        let month = NSCalendar.current.dateComponents([.month], from: date).month!
        return sections[month - 1]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CallsTableViewCell", for: indexPath) as! CallsTableViewCell

        // Configure the cell...
        var currentItem: Call
        
        currentItem = events[indexPath.section][indexPath.row] //callItems[indexPath.row]
        
        cell.manager.text = "\(currentItem.manager?.firstName ?? "") \(currentItem.manager?.lastName ?? "")"
        cell.qtyIncomingCalls.text = String(currentItem.qtyIncomingCalls)
        cell.qtyOutgoingCalls.text = String(currentItem.qtyOutgoingCalls)
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print(indexPath.row)
        performSegue(withIdentifier: "goToDetailCallView", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        performSegue(withIdentifier: "goToDetailCallView", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToDetailCallView" {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                var call: Call
//                if isFiltering {
//                    task = filteredToDoItems[indexPath.row]
//                } else {
                    call = events[indexPath.section][indexPath.row] //callItems[indexPath.row]
//                }
                
                (segue.destination as? DetailCallViewController)?.call = call
                
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
    }
    

    func transitionToLogin() {
        
        /*
        let authViewController = storyboard?.instantiateViewController(identifier: "AuthViewController") as? AuthViewController
        view.window?.rootViewController = authViewController
        view.window?.isHidden = false
        view.window?.makeKeyAndVisible()
        */
        
        guard let loginVC = storyboard?.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {return}
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
        
    }
    
}

