//
//  ViewController.swift
//  SRKit
//
//  Created by sharui on 2022/1/18.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dataSource:[DataSourceModel] = [DataSourceModel]()
    struct DataSourceModel {
        var title:String
        var clickClosure: ()->Void
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "UITableViewCellID")
        var config = cell.defaultContentConfiguration()
        config.text = self.dataSource[indexPath.row].title
        cell.contentConfiguration = config
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dataSource[indexPath.row].clickClosure()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        // Do any additional setup after loading the view.
        self.dataSource.append(
            DataSourceModel(title: "剪切图片") {
                self.navigationController?.pushViewController(ImageViewController(), animated: true)
            }
        )
        
        self.dataSource.append(
            DataSourceModel(title: "图片滚动") {
                self.navigationController?.pushViewController(SRImageCarouselViewController(), animated: true)
            }
        )
        
        self.dataSource.append(
            DataSourceModel(title: "相片选择") {
                self.navigationController?.pushViewController(SRImagePickAndCammraViewController(), animated: true)
            }
        )
        
        self.dataSource.append(
            DataSourceModel(title: "滚动指示器") {
                self.navigationController?.pushViewController(SRAnimatedPageViewController(), animated: true)
            }
        )
        
        
        
        
        
        
        tableView .reloadData()
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationController?.pushViewController(ImageViewController(), animated: true)
    }
}

