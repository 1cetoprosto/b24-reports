//
//  CallsViewController.swift
//  b24-reports
//
//  Created by leomac on 24.04.2021.
//

import UIKit

class CallsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        // Setup the Cell
        let nib = UINib(nibName: "CallsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CallsTableViewCell")
        return tableView
    }()
    
    let segmentedControl: UISegmentedControl = {
        let items = ["Day", "Week", "Month"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
        
        sortCall(items: callItems)
        setUpNavigation()
        setUpSegmentedControl()
        setUpTableView()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - SetUp View's
    
    func setUpNavigation() {
        navigationItem.title = "Calls at managers"
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9921568627, green: 0.7411764706, blue: 0.1568627451, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        //self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
    }
    
    func setUpSegmentedControl()  {
        segmentedControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 1
        
        segmentedControl.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        //segmentedControl.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        segmentedControl.tintColor = UIColor.black
    }
    
    func setUpTableView() {
        tableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        tableView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            print("Day")
            break // Day
        case 1:
            print("Week")
            break // Week
        case 2:
            print("Month")
            break // Month
        default:
            break
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return events.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = events[section].first!.date
        let month = NSCalendar.current.dateComponents([.month], from: date).month!
        return sections[month - 1]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    //    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    //        performSegue(withIdentifier: "goToDetailCallView", sender: self)
    //    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetailCallView", sender: self)
    }
    
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
}
