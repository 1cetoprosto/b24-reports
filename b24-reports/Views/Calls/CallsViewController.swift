//
//  CallsViewController.swift
//  b24-reports
//
//  Created by leomac on 24.04.2021.
//

import FirebaseAuth
import SnapKit
import UIKit

class CallsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var handle: AuthStateDidChangeListenerHandle?
    
    let callsTableViewCellReuseIdentifier = "CallsTableViewCell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CallsTableViewCell.self, forCellReuseIdentifier: callsTableViewCellReuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Load data...")
        tableView.refreshControl?.addTarget(self,
                                            action: #selector(handleRefreshControl(sender:)),
                                            for: .valueChanged)
        
        tableView.tableFooterView = UIView()
        
        return tableView
    }()
    
//    let myRefreshControl: UIRefreshControl = {
//        let refreshControl = UIRefreshControl()
//        refreshControl.attributedTitle = NSAttributedString(string: "There is an update...")
//        refreshControl.addTarget(self, action: #selector(handleRefreshControl(sender:)), for: .valueChanged)
//        return refreshControl
//    }()
    
    let groupedLabel: UILabel = {
        let groupedLabel = UILabel()
        groupedLabel.font.withSize(13)
        groupedLabel.textColor = UIColor.placeholderText
        groupedLabel.text = "grouped by:"
               
        return groupedLabel
    }()
    
    
    let segmentedControl: UISegmentedControl = {
        let items = ["Day", "Week", "Month"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = UIColor.black
        
        return segmentedControl
    }()
    
    @objc func logoutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc private func handleRefreshControl(sender: UIRefreshControl) {
        
        loadManagersFromCloud()
        loadCallsFromCloud()
        groupCall(items: callItems, at: .day)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.tableView.reloadData()
            sender.endRefreshing()
        }
    }
    
    @IBAction func unwindToCallsViewController(segue: UIStoryboardSegue) {
        
        groupCall(items: callItems, at: .day)
        
        tableView.reloadData()
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
        
        initialize()
    }
    
    // MARK: - SetUp View's
    
    func initialize() {
        view.addSubview(groupedLabel)
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
                
        groupCall(items: callItems, at: .day)
        
        setUpNavigation()
        
        groupedLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(10)
            maker.leading.equalToSuperview().inset(16)
            maker.height.equalTo(30)
            maker.width.equalTo(100)
        }
        
        segmentedControl.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(10)
            maker.leading.equalTo(groupedLabel.snp.trailing).inset(10)
            maker.trailing.equalToSuperview().inset(-16)
            maker.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(50)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
    
    func setUpNavigation() {
        
        navigationItem.title = "Calls at managers"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(transitionToSettings))
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9921568627, green: 0.7411764706, blue: 0.1568627451, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        //self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
    }
    
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
        
        groupCall(items: callItems, at: Period(segmentedControl.selectedSegmentIndex))
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {

        return groupedCalls.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = groupedCalls[section].first!.date
        return groupedPeriod(at: date, period: Period(segmentedControl.selectedSegmentIndex))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groupedCalls[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: callsTableViewCellReuseIdentifier, for: indexPath) as! CallsTableViewCell
        
        // Configure the cell...
        var currentItem: Call
        
        currentItem = groupedCalls[indexPath.section][indexPath.row] //callItems[indexPath.row]
        
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
                call = groupedCalls[indexPath.section][indexPath.row] //callItems[indexPath.row]
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

func Period(_ selectedSegmentIndex: Int) -> Periods {
    
    let period: Periods
    
    switch (selectedSegmentIndex) {
    case 0:
        period = .day
    //break // Day
    case 1:
        period =  .week
    //break // Week
    case 2:
        period =  .month
    //break // Month
    default:
        period =  .day
    //break
    }
    return period
}
