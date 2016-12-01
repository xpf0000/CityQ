//
//  CardChongzhiVC.swift
//  chengshi
//
//  Created by X on 2016/10/26.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit


class CardChongzhiVC: UITableViewController {
    
    @IBOutlet var collect: XCollectionView!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var num: UILabel!
    
    var chooseModel:CardChongzhiModel?
    {
        didSet
        {
            if let str = chooseModel?.money
            {
                num.text = str+"元"
            }
            
        }
    }
    
    func choose(sender: UIButton,model:CardChongzhiModel) {
        
        selectBtn?.selected = false
        sender.selected = true
        selectBtn = sender
        
        chooseModel = model
        
    }
    
    var model:CardModel?
    
    var selectBtn:UIButton?
    
    var harr:[CGFloat] = [44,44,10,0,10,44,70,85]
    
    var ordernumber = ""
    
    func http()
    {
        let url = APPURL+"Public/Found/?service=Hyk.getCardProduct&id=\(model!.hcmid)"
        
        XHttpPool.requestJson(url, body: nil, method: .GET) { (res) in
            
            print("res: \(res)")
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        name.text = model?.shopname
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        tableView.tableFooterView=view1
        tableView.tableHeaderView=view1
        
        collect.ViewLayout.itemSize = CGSizeMake(swidth/3.0, 38.0)
        
        collect.ViewLayout.minimumLineSpacing = 16.0
        collect.ViewLayout.minimumInteritemSpacing = 0.0
        collect.ViewLayout.sectionInset = UIEdgeInsetsMake(16.0, 0.0, 16.0, 0.0)
        
        let url = APPURL+"Public/Found/?service=Hyk.getCardProduct&id=\(model!.id)"
        
        collect.setHandle(url, pageStr: "[page]", keys: ["data","info"], model: CardChongzhiModel.self, CellIdentifier: "CardChongzhiCell")
        
        collect.httpHandle.BeforeBlock {[weak self] (res) in
            
            self?.harr[3] = CGFloat( 16.0+ceil(Double(res.count)/3.0)*54 )
            
            self?.tableView.reloadData()
            
        }
        
        collect.httpHandle.handle()

    }

    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row == 0 || indexPath.row == 5)
        {
            cell.separatorInset=UIEdgeInsetsMake(0, 15, 0, 15)
            if(IOS_Version>=8.0)
            {
                if #available(iOS 8.0, *) {
                    cell.layoutMargins=UIEdgeInsetsMake(0, 15, 0, 15)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        else
        {
            cell.separatorInset=UIEdgeInsetsMake(0, swidth, 0, 0)
            if(IOS_Version>=8.0)
            {
                if #available(iOS 8.0, *) {
                    cell.layoutMargins=UIEdgeInsetsMake(0, swidth, 0, 0)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        self.tableView.separatorInset=UIEdgeInsetsZero
        if(IOS_Version>=8.0)
        {
            if #available(iOS 8.0, *) {
                self.tableView.layoutMargins=UIEdgeInsetsZero
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return harr[indexPath.row]
    }
    
    
    @IBAction func submit(sender: UIButton) {
        
        if model == nil {return}
        if chooseModel == nil
        {
            ShowMessage("请选择充值金额")
            return
        }
        
        XWaitingView.show()
        sender.enabled = false
        
        let url = APPURL+"Public/Found/?service=hyk.paysign&uid=\(Uid)&username=\(Uname)&mcardid=\(model!.id)&cpid=\(chooseModel!.id)"
        
        XHttpPool.requestJson(url, body: nil, method: .POST) {[weak self] (res) in
            
            if let str = res?["data"]["orderinfo"]["ordernumber"].string
            {
                self?.ordernumber = str
            }
            
            if let str = res?["data"]["info"].string
            {
                let appScheme = "Xchengshiquan";
                
                AlipaySDK.defaultService().payOrder(str, fromScheme: appScheme, callback: { [weak self](o) -> Void in
                    
                    XWaitingView.hide()
                    
                    print("pay result: \(o)")
                    
                    let resultStatus = o["resultStatus"] as? String
                    
                    if(resultStatus != nil)
                    {
                        if(resultStatus!.numberValue.intValue == 9000)
                        {
                            NSNotificationCenter.defaultCenter().postNotificationName("PaySuccess", object: nil)
                            XAlertView.show("支付成功", block: {[weak self] in
                                
                                
                                let vc = HtmlVC()
                                
                                vc.baseUrl = TmpDirURL
                                
                                if let u = TmpDirURL?.URLByAppendingPathComponent("czsuccess.html"),let onum = self?.ordernumber
                                {
                                    vc.url = "\(u)?ordernumber=\(onum)&uid=\(Uid)&uname=\(Uname)"
                                }
                                
                                vc.hidesBottomBarWhenPushed = true
                                vc.title = "充值"
                                
                                self?.navigationController?.pushViewController(vc, animated: true)
                                
                                
                            })
                        }
                        else
                        {
                            var memo = o["memo"] as? String
                            memo = memo == nil ? "" : memo
                            memo = memo == "" ? "支付失败" : memo
                            
                            XAlertView.show(memo!, block: nil)
                            
                            sender.enabled = true
                        }
                    }
                    else
                    {
                        XAlertView.show("支付失败", block: {[weak self] in
                            self?.pop()
                            })
                    }
                    
                    
                })
            }
            
            
            print("res: \(res)")
        }
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
