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
    ///MARK:- Header Refresh Success Block
    typealias HeaderRefreshSuccessBlock = () -> ()
    @IBAction func btnBackClick(){
    popVC()
    }
    
    @IBAction func btnLogout(){
        AppManager.Manager.logoutFromApp(fromVc: self)
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
            tableView?.separatorStyle = .none
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
        
        
        
        func setTableViewBgView (_title : String? , table : UITableView? , dataSource : Array<Any>? , isHideImage : Bool = false , txtAlignment : NSTextAlignment = .center, img : UIImage? =  UIImage.init(named: "no_data.png")) { // no-data
            
            guard let tableView = table else {return}
            if (/dataSource?.count == 0) {
                guard let emptyLabelView = Bundle.main.loadNibNamed("EmptyScreenView", owner: self, options: nil)?.first else { return }
                let emptyLabel = emptyLabelView as? EmptyScreenView
                
                emptyLabel?.reloadBtn?.isHidden = true
                emptyLabel?.frame = (tableView.backgroundView?.frame) ?? CGRect.init(x: 0, y: 0, width: /tableView.frame.width, height: /tableView.frame.height)
                emptyLabel?.img?.isHidden = /isHideImage
                emptyLabel?.img?.image = img
                emptyLabel?.lblTitle?.textAlignment = txtAlignment
                emptyLabel?.lblTitle?.text = _title ?? "NoDataFound".localized
                tableView.backgroundView = emptyLabel
                //dataSource? = []
                tableView.reloadData()
                
            }else {
                tableView.backgroundView = nil
            }
        }
        //
        //    ///Set up Header Refresh for Table View
        func tableViewHeaderRefresh(_ table: UITableView?, responseBlock: @escaping HeaderRefreshSuccessBlock) {
            
            let header = DefaultRefreshHeader.header()
            header.tintColor = #colorLiteral(red: 0.3176470588, green: 0.4588235294, blue: 0.9647058824, alpha: 1)
            header.imageRenderingWithTintColor = true
            header.durationWhenHide = 0.4
            header.setText("", mode: .pullToRefresh)
            header.setText("", mode: .releaseToRefresh)
            header.setText("", mode: .refreshSuccess)
            header.setText("", mode: .refreshing)
            header.setText("", mode: .refreshFailure)
            table?.configRefreshHeader(with: header,container:self) {
                responseBlock()
                ez.dispatchDelay(0.8, closure: {
                    table?.switchRefreshHeader(to: .normal(.success, 0.3))
                })
            }
        }
        
    }
    
    



