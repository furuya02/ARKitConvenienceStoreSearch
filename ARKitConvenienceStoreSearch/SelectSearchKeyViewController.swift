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
    
    var searchKeys:[SearchKey] = []
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepare()
    }

    func createPlaces() -> [SearchKey] {
        var places:[SearchKey] = []
        places.append(SearchKey(title: "コンビニ", key: "convenience_store", image: UIImage(named: "convenienceStore")!))
        places.append(SearchKey(title: "ホテル", key: "lodging", image: UIImage(named: "hotel")!))
        places.append(SearchKey(title: "ガソリンスタンド", key: "gas_station", image: UIImage(named: "gasStation")!))
        places.append(SearchKey(title: "駐車場", key: "parking", image: UIImage(named: "parking")!))
        places.append(SearchKey(title: "駅（電車）", key: "train_station", image: UIImage(named: "station")!))
        places.append(SearchKey(title: "駅（バス）", key: "bus_station", image: UIImage(named: "bus")!))
        return places
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Cellが選択された場合も、Cell以外が選択された場合も、ここで処理する（UITableView+TouchEvent.swift）
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: point!) {
            self.selectedIndex = indexPath.row
            self.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.performSegue(withIdentifier: "selectedSearchKeySegue", sender: nil)
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
