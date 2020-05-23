//
//  BaseViewController.swift
//  SpotPraise
//
//  Created by admin on 22/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
 import UIKit

class BaseViewController: UIViewController {

    @IBAction func btnBackClick(){
    popVC()
    }
    
    func popVC() {
        
        if self.navigationController != nil {
            _ = self.navigationController?.popViewController(animated: true)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func pushVC(_ vc: UIViewController? , animated : Bool? = true) {
        
        guard let vc = vc else {
            Logs.printLog("Unable to fine VC!!")
            return}
        navigationController?.pushViewController(vc, animated: /animated)
    }
        //MARK: - OUTLETS
     @IBOutlet weak var tableView: UITableView?
       // @IBOutlet weak var collectionView: UICollectionView?
        //@IBOutlet weak var navBar:UINavigationBar?
        //@IBOutlet weak var barButton:UIBarButtonItem?
        
      //  var emptyViewHolder = UIView()
        
        ///MARK:- Header Refresh Success Block
       //typealias HeaderRefreshSuccessBlock = () -> ()
        
        //MARK:- PROPERTIES
//        var tableDatasource : TableViewDataSource? {
//            didSet{
//                tableView?.dataSource = tableDatasource
//                tableView?.delegate = tableDatasource
//                tableView?.reloadData()
//            }
//        }
//
//        @objc func reload(){
//
//        }
//        //static var pdfId = 0
//
//        var collectionDataSource: CollectionViewDataSource? {
//            didSet{
//                collectionView?.dataSource = collectionDataSource
//                collectionView?.delegate = collectionDataSource
//                collectionView?.reloadData()
//            }
//        }
    
        //MARK: - LIFE CYCLE FUNCTIONS
        override func viewDidLoad() {
            super.viewDidLoad()
//            navBar?.tintColor = #colorLiteral(red: 0.3882781863, green: 0.5528389812, blue: 0.973059833, alpha: 1)
//            navBar?.isTranslucent = false
//            navBar?.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: CustomFonts.Montserrat_Medium.rawValue, size: 20)!,
//                                           NSAttributedString.Key.foregroundColor:UIColor.white]
//            //        self.view.addTapGesture { [weak self] (gesture) in
//            //            gesture.delegate = self
//            //            self?.view.endEditing(true)
//            //        }
//
//            barButton?.action = #selector(buttonClicked(sender:))
//
            
            
        }
        
//        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        }
//        @objc func buttonClicked(sender: UIBarButtonItem) {
//            self.popVC()
//        }
    }//
    
    //MARK:- CUSTOM FUNCTIONS
    extension BaseViewController {
        
        
        
        //MARK:- Setup Header Refresh
        //    func refreshScrollViewHeader(scroll : UIScrollView?, responseBlock: @escaping HeaderRefreshSuccessBlock) {
        //
        //        let header = DefaultRefreshHeader.header()
        //        header.tintColor = #colorLiteral(red: 0.5032528639, green: 0.812071383, blue: 0.7847238183, alpha: 1)
        //        header.imageRenderingWithTintColor = true
        //        header.durationWhenHide = 0.4
        //        header.setText("", mode: .pullToRefresh)
        //        header.setText("", mode: .releaseToRefresh)
        //        header.setText("", mode: .refreshSuccess)
        //        header.setText("", mode: .refreshing)
        //        header.setText("", mode: .refreshFailure)
        //        scroll?.configRefreshHeader(with: header, container: self, action: {
        //            responseBlock()
        //            ez.dispatchDelay(0.8, closure: {
        //                scroll?.switchRefreshHeader(to: .normal(.success, 0.3))
        //            })
        //        })
        //    }
        
        
    }
    
    



