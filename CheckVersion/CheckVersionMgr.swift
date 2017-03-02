//
//  CheckVersionMgr.swift
//  CheckVersion_Swift
//
//  Created by mac on 17/2/24.
//  Copyright © 2017年 hang. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

/** 上次检查的时间*/
let LastCheckTime = "lastchecktime"

/** 检查时间间隔，Min*/
let CheckAgainInterval = 60

/** iTunes 地址*/
let ItunesAdress = "http://itunes.apple.com/lookup?bundleId="

public enum AppStatus : Int {
    case normal
    case dataError
    case noInItunes
}

public class CheckVersionMgr : NSObject , SKStoreProductViewControllerDelegate{
    
    public static let shareInstance = CheckVersionMgr()
    private override init() {}
    
    private var window: UIWindow {
        let appDelegate = UIApplication.shared.delegate
        return (appDelegate?.window!)!
    }
    
    private var privateInfoModel : AppInfoModel?
    
    /** 默认从APP跳转出去到AppStore进行更新， 设置false为应用内打开*/
    open var openTrackUrlInAppStore: Bool = true
    
    
    //MARK: - Method
    
    /** 检测新版本(使用默认提示框)*/
    public func checkVersionWithSystemAlert() {
        let status = shouldStartCheck()
        if status {
            getVersionInfo(completed: { (result) in
                let resultCount = result?["resultCount"] as! NSNumber
                
                if resultCount.intValue == 1 {
                    let results = (result?["results"] as? NSArray)?.firstObject
                    let infoModel = AppInfoModel.init(dic: results as! [String : AnyObject])
                    self.privateInfoModel = infoModel
                    
                    let showAlert = self.compareVersion(self.getLocalVersion(), infoModel.version as! String)
                    if showAlert {
                        let alertController = UIAlertController.init(title: "发现新版本", message: infoModel.releaseNotes as? String, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction.init(title: "稍后再说", style: .default, handler: { (action) in
                            //关闭
                        }))
                        alertController.addAction(UIAlertAction.init(title: "火速更新", style: .default, handler: { (action) in
                            if self.openTrackUrlInAppStore {
                                self.openInAppStore(self.privateInfoModel!)
                            } else {
                                self.openInApp(self.privateInfoModel!)
                            }
                        }))
                        self.window.rootViewController?.present(alertController, animated: true, completion: nil)
                        
                    } else {
                        //不需要更新
                    }
                    
                } else {
                    //搜索结果为空，可能App尚未上架
                }
            }, failure: { (error) in
                debugPrint(error!)
            })
        }
    }
    
    /** 检测新版本(自定义提示框)*/
    public func checkVersionWithCustomView( getInfoBlock:@escaping (_ infoModel:AppInfoModel?, _ status:AppStatus)-> ()) {
        let status = shouldStartCheck()
        if status {
            getVersionInfo(completed: { (result) in
                let resultCount = result?["resultCount"] as! NSNumber
                
                if resultCount.intValue == 1 {
                    let results = (result?["results"] as? NSArray)?.firstObject
                    let infoModel = AppInfoModel.init(dic: results as! [String : AnyObject])
                    getInfoBlock(infoModel, .normal)
                } else {
                    //搜索结果为空，可能App尚未上架
                    getInfoBlock(nil, .noInItunes)
                }
            }, failure: { (errors) in
                debugPrint(errors!)
                getInfoBlock(nil, .dataError)
            })
        }
    }
    
    
    /** 更新时在APP应用内打开更新页面*/
    public func openInApp(_ model:AppInfoModel) {
        let storeVC = SKStoreProductViewController.init()
        storeVC.delegate = self
        let paramete = [SKStoreProductParameterITunesItemIdentifier: (model.trackId!)]
        storeVC.loadProduct(withParameters:paramete , completionBlock: { (loadFlag, error) in
            if !loadFlag {
                storeVC.dismiss(animated: true, completion: nil)
                UIApplication.shared.openURL(URL.init(string: model.trackViewUrl as! String)!)
            }
        })
        self.window.rootViewController?.present(storeVC, animated: true, completion: nil)
    }
    
    /** 更新时跳转到Appstore页面*/
    public func openInAppStore(_ model:AppInfoModel) {
        UIApplication.shared.openURL(URL.init(string: model.trackViewUrl as! String)!)
    }
    
    
    public func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
}

internal extension CheckVersionMgr {
    
    /** 检查策略：与上次检查版本的时间间隔1Hour，减少网络频繁请求*/
    func shouldStartCheck() -> Bool {
        let userdefault = UserDefaults.standard
        let lastTime = userdefault.object(forKey: LastCheckTime)
        let nowTime = NSDate()
        
        if (lastTime != nil) {
            let timeInterval = nowTime.timeIntervalSince1970 - (lastTime as! NSDate).timeIntervalSince1970
            if Int(timeInterval)/60 >=  CheckAgainInterval {
                userdefault.setValue(nowTime, forKey: LastCheckTime)
                userdefault.synchronize()
                return true
            } else {
                return false
            }
        } else {
            userdefault.setValue(nowTime, forKey: LastCheckTime)
            userdefault.synchronize()
            return true
        }
    }
    
    
    //向iTunes获取应用信息
    func getVersionInfo(completed:@escaping (_ result: NSDictionary?)-> (), failure:@escaping (_ error: NSError?)-> ()) {
        let infoDict = Bundle.main.infoDictionary
        let appbundleId : String? = infoDict!["CFBundleIdentifier"] as? String
        let url = ItunesAdress + appbundleId!
        
        //异步请求解决4G卡顿问题，设置缓存策略,不让加载系统中缓存的数据
        let request = NSMutableURLRequest.init(url: NSURL.init(string: url) as! URL)
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        let cache = URLCache.shared
        let response = cache.cachedResponse(for: request as URLRequest)
        if (response != nil) {
            cache.removeAllCachedResponses()
        }
        
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) { (response, data, connectionError) in
            if data != nil {
                let appInfoDic = try? JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableLeaves)
                completed(appInfoDic as! NSDictionary?)
            } else {
                failure(connectionError as NSError?)
            }
        }
    }
    
    /** 本地版本号*/
    func getLocalVersion() -> String {
        let localversion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        return localversion as! String
    }
    
    /** 比较版本号*/
    func compareVersion(_ localVersion:String, _ itunesVersion:String) -> Bool {
        let isnew = localVersion.compare(itunesVersion) == .orderedAscending
        if isnew {
            return true
        }
        return false
    }
    
}
