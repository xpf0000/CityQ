//
//  CardTimesChongzhiVC.swift
//  chengshi
//
//  Created by X on 2016/10/26.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

class CardTimesChongzhiVC: UITableViewController {
    
    @IBOutlet var collect: XCollectionView!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var num: UILabel!
    
    @IBOutlet var youhuiLabel: UILabel!
    
    var youhui:YouhuiquanModel?
    {
        didSet
        {
            if let str = youhui?.money
            {
                youhuiLabel?.text = str+"元"
            }
            
        }
    }
    
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
    
    var ordernumber = ""
    
    func choose(sender: UIButton,model:CardChongzhiModel) {
        
        selectBtn?.selected = false
        sender.selected = true
        selectBtn = sender
        
        chooseModel = model
        
    }
    
    var btn:UIButton?
    
    var type = 0
    
    var model:CardModel?
    
    var selectBtn:UIButton?
    
    var harr:[CGFloat] = [44,44,10,0,10,42,10,44,70,85]
    
    func payFail()
    {
        btn?.enabled = true
    }
    
    func paySuccess()
    {
        let vc = HtmlVC()
        
        vc.baseUrl = TmpDirURL
        
        if let u = TmpDirURL?.URLByAppendingPathComponent("czsuccess.html")
        {
            vc.url = "\(u)?ordernumber=\(ordernumber)&uid=\(Uid)&uname=\(Uname)"
        }
        
        vc.hidesBottomBarWhenPushed = true
        vc.title = "充值"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(paySuccess), name: "PaySuccess", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(payFail), name: "PayFail", object: nil)
        
        name.text = model?.shopname
                
        let view1=UIView()
        view1.backgroundColor=UIColor.clearColor()
        tableView.tableFooterView=view1
        tableView.tableHeaderView=view1
        
        if swidth == 320.0
        {
            collect.ViewLayout.itemSize = CGSizeMake((swidth-90)/2.0, 38.0)
            collect.ViewLayout.minimumLineSpacing = 16.0
            collect.ViewLayout.minimumInteritemSpacing = 30.0
            collect.ViewLayout.sectionInset = UIEdgeInsetsMake(16.0, 30.0, 16.0, 30.0)
        }
        else
        {
            collect.ViewLayout.itemSize = CGSizeMake((swidth-80)/3.0, 38.0)
            collect.ViewLayout.minimumLineSpacing = 16.0
            collect.ViewLayout.minimumInteritemSpacing = 20.0
            collect.ViewLayout.sectionInset = UIEdgeInsetsMake(16.0, 20.0, 16.0, 20.0)
        }
        
        let url = APPURL+"Public/Found/?service=Hyk.getCardProduct&id=\(model!.cardid)"
        
        collect.setHandle(url, pageStr: "[page]", keys: ["data","info"], model: CardChongzhiModel.self, CellIdentifier: "CardTimeChongzhiCell")
        
        collect.postDict = ["type":type]
        
        collect.httpHandle.BeforeBlock {[weak self] (res) in
            
            if res.count == 0
            {
                self?.harr[3] = 0.0
                self?.harr[4] = 0.0
            }
            else
            {
                if swidth == 320.0
                {
                    self?.harr[3] = CGFloat( 16.0+ceil(Double(res.count)/2.0)*54 )
                }
                else
                {
                    self?.harr[3] = CGFloat( 16.0+ceil(Double(res.count)/3.0)*54 )
                }
                
                
                self?.harr[4] = 10.0
            }
            
            self?.tableView.reloadData()
            
        }
        
        collect.httpHandle.handle()
        
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row == 0 || indexPath.row == 7)
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
        
        btn = sender
        
        if model == nil {return}
        if chooseModel == nil
        {
            ShowMessage("请选择充值金额")
            return
        }
        
        XWaitingView.show()
        sender.enabled = false
        
        var url = APPURL+"Public/Found/?service=hyk.paysign&uid=\(Uid)&username=\(Uname)&mcardid=\(model!.id)&cpid=\(chooseModel!.id)"
        
        if let m = youhui
        {
            url = url+"&yhqid="+m.id
        }
        
        XHttpPool.requestJson(url, body: nil, method: .POST) {[weak self] (res) in
            
            XWaitingView.hide()
            
            if let str = res?["data"]["orderinfo"]["ordernumber"].string
            {
                self?.ordernumber = str
            }
            
            if let str = res?["data"]["info"].string
            {
                let appScheme = "Xchengshiquan";
                
                AlipaySDK.defaultService().payOrder(str, fromScheme: appScheme, callback: { [weak self](o) -> Void in
                    
                    print("pay result: \(o)")
                    
                    let resultStatus = o["resultStatus"] as? String
                    
                    if(resultStatus != nil)
                    {
                        if(resultStatus!.numberValue.intValue == 9000)
                        {
                            NSNotificationCenter.defaultCenter().postNotificationName("PaySuccess", object: nil)
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
                        XAlertView.show("支付失败", block: nil)
                    }
                    
                    
                    })
                
                
            }
            
            
            
            print("res: \(res)")
        }
        
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    
        if indexPath.row == 5,let sid = model?.shopid
        {
            if chooseModel == nil{
                ShowMessage("请先选择充值金额")
                return
            }
            
            let vc = CardUserYouhuiquanVC()
            vc.sid = sid
            vc.moneyModel = chooseModel
            vc.onChoose({ [weak self](m) in
                
                self?.youhui = m as? YouhuiquanModel
                
            })
            
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        print("CardTimesChongzhiVC viewWillAppear !!!!!!")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
