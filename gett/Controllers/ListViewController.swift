//
//  ListViewController.swift
//  gett
//
//  Created by nathan on 14/01/2018.
//  Copyright © 2018 nathan. All rights reserved.
//

import UIKit
import RxSwift

let identifier = "PlaceCell"

class ListViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var actInd: UIActivityIndicatorView!
    @IBOutlet weak var tblList: UITableView!
    let viewModel = PlacesViewModel()
    private let disposeBag = DisposeBag()
    var nearbyArr = [Place]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bind()
    }

    private func configureTableView() {
        let nib = UINib(nibName: identifier, bundle: nil)
        tblList.register(nib, forCellReuseIdentifier: identifier);
        tblList.rowHeight = 60
    }
    func bind(){
        viewModel.places.asObservable()
            .subscribe { [weak self](near) in
            self?.nearbyArr = near.element ?? []
            self?.tblList.reloadData()
        }
        .disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: PlaceCell.self)
        let place = nearbyArr[indexPath.row]
        cell.setup(item: place)
        return cell
    }
}
