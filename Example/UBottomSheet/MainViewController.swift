//
//  MainViewController.swift
//  UBottomSheet
//
//  Created by OfTheWolf on 09/19/2019.
//  Copyright (c) 2019 OfTheWolf. All rights reserved.
//

import UIKit

typealias MainItem = (title: String, subtitle: String)

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var items: [MainItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Features"

        tableView.delegate = self
        tableView.dataSource = self

        items.append(("Apple Maps Like Sheet & Child Sheets", "Similar to apple maps bottom sheet on ios."))
        items.append(("Navigation In Sheet", "Sheet View Controllers are embedded in a UINavigationController"))
        items.append(("Pull To Dismiss", "Dissmiss the sheet by pulling down"))
        items.append(("Multiple Sheet Positions", "Implement UBottomSheetCoordinatorDataSource to override default implementation"))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        cell.detailTextLabel?.text = items[indexPath.row].subtitle
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: appleMapsAction(items[indexPath.row])
        case 1: navigationDemoAction(items[indexPath.row])
        case 2: pullToDismissDemoAction(items[indexPath.row])
        case 3: customDataSourceDemoAction(items[indexPath.row])
        default: break
        }
    }
    
    //MARK: Actions
    
    func appleMapsAction(_ item: MainItem){
        let vc = MapsViewController()
        vc.title = item.title
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigationDemoAction(_ item: MainItem){
        let vc = SimpleViewController()
        vc.sheetVC = LabelViewController()
        vc.useNavController = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pullToDismissDemoAction(_ item: MainItem){
        let vc = SimpleViewController()
        vc.sheetVC = LabelViewController()
        vc.dataSource = PullToDismissDataSource()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func customDataSourceDemoAction(_ item: MainItem){
        let vc = SimpleViewController()
        vc.sheetVC = ListViewController()
        vc.dataSource = MyDataSource()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
