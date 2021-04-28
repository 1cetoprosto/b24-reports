//
//  CallsViewController.swift
//  b24-reports
//
//  Created by leomac on 24.04.2021.
//

import UIKit
import FirebaseAuth

class CallsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var handle: AuthStateDidChangeListenerHandle?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        // Setup the Cell
        let nib = UINib(nibName: "CallsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CallsTableViewCell")
        
        return tableView
    }()
    
    let groupedLabel: UILabel = {
        let groupedLabel = UILabel()
        groupedLabel.translatesAutoresizingMaskIntoConstraints = false
        groupedLabel.text = "grouped by:"
        
        return groupedLabel
    }()
    
    
    let segmentedControl: UISegmentedControl = {
        let items = ["Day", "Week", "Month"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()
    
    @objc func logoutAction(_ sender: Any) {
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
        
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // [START remove_auth_listener]
        Auth.auth().removeStateDidChangeListener(handle!)
        // [END remove_auth_listener]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(groupedLabel)
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
        
        
        sortCall(items: callItems, at: .day)
        setUpNavigation()
        setUpgroupedLabel()
        setUpSegmentedControl()
        setUpTableView()
        
        //self.navigationItem.setLeftBarButton(item1, animated: true)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - SetUp View's
    
    func setUpNavigation() {
        
        navigationItem.title = "Calls at managers"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(transitionToSettings))
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9921568627, green: 0.7411764706, blue: 0.1568627451, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        //self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
    }
    
    func setUpgroupedLabel() {
        groupedLabel.font.withSize(13)
        groupedLabel.textColor = UIColor.placeholderText
        groupedLabel.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        groupedLabel.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        groupedLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        groupedLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setUpSegmentedControl()  {
        segmentedControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo:groupedLabel.trailingAnchor, constant: 10).isActive = true
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
            sortCall(items: callItems, at: .day)
            //break // Day
        case 1:
            sortCall(items: callItems, at: .week)
            //break // Week
        case 2:
            sortCall(items: callItems, at: .month)
            //break // Month
        default:
            sortCall(items: callItems, at: .day)
            //break
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return calls.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = calls[section].first!.date
        let formatter = DateFormatter()
        let titleSection: String
        
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            formatter.dateFormat = "d MMMM YYYY"
            titleSection = formatter.string(from: date)
        case 1:
            formatter.dateFormat = "d MMMM YYYY"
            titleSection = "\(formatter.string(from: date.startOfWeek)) - \(formatter.string(from: date.endOfWeek))"
        case 2:
            formatter.dateFormat = "MMMM YYYY"
            titleSection = formatter.string(from: date)
        default:
            formatter.dateFormat = "d MMMM YYYY"
            titleSection = formatter.string(from: date)
        }
               
        return titleSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return calls[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CallsTableViewCell", for: indexPath) as! CallsTableViewCell
        
        // Configure the cell...
        var currentItem: Call
        
        currentItem = calls[indexPath.section][indexPath.row] //callItems[indexPath.row]
        
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
                call = calls[indexPath.section][indexPath.row] //callItems[indexPath.row]
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
    
    @objc func transitionToSettings() {
        
        let settingsVC = storyboard?.instantiateViewController(identifier: "SettingsViewController") as? SettingsViewController
        navigationController?.pushViewController(settingsVC!, animated: true)
        
        //performSegue(withIdentifier: "goToSettings", sender: self)
        
//        let settingsVC = storyboard?.instantiateViewController(identifier: "SettingsViewController") as? SettingsViewController
//        view.window?.rootViewController = settingsVC
//        view.window?.isHidden = false
//        view.window?.makeKeyAndVisible()
        
        
//        guard let settingsVC = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else {return}
//        //settingsVC.modalPresentationStyle = .fullScreen
//        present(settingsVC, animated: true, completion: nil)
        
    }
    
}
