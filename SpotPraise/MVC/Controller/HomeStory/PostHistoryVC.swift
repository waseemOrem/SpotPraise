//
//  PostHistoryVC.swift
//  SpotPraise
//
//  Created by admin on 23/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class PostHistoryVC: BaseViewController {
 
    //MARK: -Paramters
    var postHistoryData:[PostHistoryData]?
    
     override func viewDidLoad() {
        super.viewDidLoad()
        
       configureTableView()
        getPostHistory()
        // Do any additional setup after loading the view.
    }
    
    deinit {
        print("deniy")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        headerRefresh()
    }
}

//MARK: -Cusotm func

extension PostHistoryVC{
    
    func configureTableView(){
        
        self.tableView?.register(UINib(nibName: TableCells.PostHistoryTableCell.rawValue, bundle: nil), forCellReuseIdentifier: TableCells.PostHistoryTableCell.rawValue)
        tableView?.separatorStyle = .none
        //  tableView?.estimatedRowHeight = UITableView.automaticDimension
        // tableView?.rowHeight = UITableView.automaticDimension
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        reloadPostTable()
    }
    //Header Refresh
    func headerRefresh() {
        
        self.tableViewHeaderRefresh(self.tableView) { [weak self] in
            self?.getPostHistory()
            //self!.getRegions()
        }
    }
    func reloadPostTable(with str : String? = "NoDataFound".localized) {
        
        self.tableView?.reloadData()
        setTableViewBgView(_title: /str, table: tableView, dataSource: self.postHistoryData)
    }
    func getPostHistory(){
        
        APIManager.requestWebServerWithAlamo(to: .postlist, httpMethd: .post, completion: { [weak self] postResponse in
            let resData  = (try? JSONDecoder().decode(PostHistoryRootClass.self, from: postResponse.data! ))
           if postResponse.response?.statusCode == 200{
                guard  resData?.data != nil else {
//                    Alert.shared.showAlertWithCompletion(buttons: ["Dismiss"], msg: MESSAGES.RESPONSE_ERROR.rawValue, success: {_ in })
                    return}
                 self?.postHistoryData = resData?.data
                self?.reloadPostTable()
            }
            
            
        })
    }
}
//MARK: -UITableViewDelegate,UITableViewDataSource,cellButtonTapped
extension PostHistoryVC:UITableViewDelegate,UITableViewDataSource,cellButtonTapped{
    func onCellButtonClicked(cellActions: Actions, index: IndexPath) {
        switch cellActions {
        case .REPOST:
            console("Repost")
            
        case .VIEW_DETAILS:
            guard let vc = self.getVC(withId: VC.PostDetailVC.rawValue, storyBoardName: Storyboards.Home.rawValue) as? PostDetailVC else {
                return
            }
            vc.postData = self.postHistoryData?[index.row]
            self.pushVC(vc)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postHistoryData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.PostHistoryTableCell.rawValue) as? PostHistoryTableCell
        cell?.delegate = self
        cell?.indexP = indexPath
        cell?.item = postHistoryData?[indexPath.row]
        return cell!
    }
 
}

