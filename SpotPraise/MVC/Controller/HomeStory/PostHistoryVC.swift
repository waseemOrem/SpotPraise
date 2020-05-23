//
//  PostHistoryVC.swift
//  SpotPraise
//
//  Created by admin on 23/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class PostHistoryVC: BaseViewController {
var a = "The model regarding paragraph length that your teacher undoubtedly taught you involves a topic sentence, a number of facts that support that core idea, and a concluding sentence. The proviso about the number of sentences between the topic sentence and the conclusion was not given to you because it was the magic formula for creating paragraphs of the perfect length; rather, your educator was attempting to give you a good reason to do adequate research on your topic. Academic writing yields the best examples of the topic-support-conclusion paragraph structure."
    
    var b = "Various educators teach rules governing the length of paragraphs. They may say that a paragraph should be 100 to 200 words long, or be no more than five or six sentences. But a good paragraph should not be measured in characters, words, or sentences. The true measure of your paragraphs should be ideas."
    
    var c = "fgdf"
    var arrn = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        arrn = [a,b,c]

        self.tableView?.register(UINib(nibName: TableCells.PostHistoryTableCell.rawValue, bundle: nil), forCellReuseIdentifier: TableCells.PostHistoryTableCell.rawValue)
        tableView?.separatorStyle = .none
        tableView?.estimatedRowHeight = UITableView.automaticDimension
        tableView?.rowHeight = UITableView.automaticDimension
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        tableView?.reloadData()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PostHistoryVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrn.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.PostHistoryTableCell.rawValue) as? PostHistoryTableCell
        cell!.lblDescription?.text = arrn[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       // print("Height \( arrn[indexPath.row].heightWithConstrainedWidth(width: tableView.frame.width, font: UIFont(name: CustomFontPoppins.Light.rawValue, size: 14.0)!))")
        return  UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.getVC(withId: VC.PostDetailVC.rawValue, storyBoardName: Storyboards.Home.rawValue) as? PostDetailVC else {
            return
        }
        self.pushVC(vc)
    }
    
}

//extension String {
//    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
//        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
//        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font: font], context: nil)
//        return boundingBox.height
//    }
//}
