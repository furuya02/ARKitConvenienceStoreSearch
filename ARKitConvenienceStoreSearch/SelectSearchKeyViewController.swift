//
//  SearchViewController.swift
//  ARKitConvenienceStoreSearch
//
//  Created by . SIN on 2017/11/12.
//  Copyright © 2017年 SAPPOROWORKS. All rights reserved.
//

import UIKit

class SelectSearchKeyViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var searchKeys:[SearchKey] = []
    private var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepare()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createPlaces() -> [SearchKey] {
        var places:[SearchKey] = []
        places.append(SearchKey(title: "コンビニ", key: "combinience", image: UIImage(named: "convenienceStore")!))
        places.append(SearchKey(title: "ホテル", key: "hotel", image: UIImage(named: "hotel")!))
        places.append(SearchKey(title: "ガソリンスタンド", key: "gasstand", image: UIImage(named: "gasStation")!))
        places.append(SearchKey(title: "駐車場", key: "parcking", image: UIImage(named: "parking")!))
        places.append(SearchKey(title: "駅", key: "station", image: UIImage(named: "station")!))
        return places
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: point!) {
            self.selectedIndex = indexPath.row
            self.tableView.reloadData()
            print("search key:\(self.searchKeys[selectedIndex].key)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    func prepare(){
        
        tableView.dataSource = self
        searchKeys = createPlaces()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        tableView.rowHeight = 85
        tableView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
    }
}

extension SelectSearchKeyViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let place = searchKeys[indexPath.row]
        cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)

        if let view: UIView = cell.contentView.viewWithTag(3) {
            view.layer.cornerRadius = 15
            view.clipsToBounds = true
            if (selectedIndex == indexPath.row) {
                view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
            } else {
                view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
            }
        }

        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        imageView.image = place.image
        let label = cell.contentView.viewWithTag(2) as! UILabel
        label.text = place.title

        return cell
    }
}
