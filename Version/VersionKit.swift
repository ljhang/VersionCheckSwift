//
//  VersionKit.swift
//  Version
//
//  Created by 李建航 on 2018/7/6.
//  Copyright © 2018 lee. All rights reserved.
//

import Foundation
import RxSwift
import AlamofireObjectMapper
import Alamofire
import StoreKit

public class VersionKit: NSObject {
    
    // MARK: - public
    
    public static let shareInstance = VersionKit()
    
    public static let bundle = Bundle(for: VersionKit.self)
    
    public weak var delegate: VersionKitDelegate?
    
    /// APP版本检测间隔
    public let detectType: Variable<DetectType> = Variable(.immediate)
    
    // MARK: - private
    
    /// 上次检查时间
    private let lastDetectTime: Variable<String?> = Variable(UserDefaults.standard.string(forKey: Constant.lastDetectTimeKey))
    private var rx_lastDetectTime: Observable<String?> {
        return self.lastDetectTime.asObservable()
    }
    
    /// 跳过检测的版本
    private let skipDetectVersion: Variable<String?> = Variable(UserDefaults.standard.string(forKey: Constant.skipDetectVersionKey))
    private var rx_skipDetectVersion: Observable<String?> {
        return self.skipDetectVersion.asObservable()
    }
    
    /// 是否发起检测请求
    private let shouldStartDetectApp = Variable<Bool>(false)
    
    private let info: Variable<AppInfoResults?> = Variable(nil)
    
    /// 重新检测
    private let reDetect = PublishSubject<Void>()
    
    private let disposeBag = DisposeBag()
    
    private override init() {
        
        super.init()
        
        self.lastDetectTime.asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { _timeStr in
                UserDefaults.standard.set(_timeStr, forKey: Constant.lastDetectTimeKey)
            })
            .disposed(by: self.disposeBag)
        
        self.skipDetectVersion.asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { _version in
                UserDefaults.standard.set(_version, forKey: Constant.skipDetectVersionKey)
            })
            .disposed(by: self.disposeBag)
        
        
        Observable.combineLatest(self.rx_lastDetectTime.asObservable(),
                                 self.detectType.asObservable(),
                                 self.reDetect.asObservable()) { (detectTime, type, _) -> Bool in
                                    switch type {
                                    case .immediate:
                                        return true
                                    case .never:
                                        return false
                                    case .interval(let day):
                                        if let _detectTime = detectTime, let detectDate = Tools.stringToDate(_detectTime) {
                                            var components = Calendar.current.dateComponents([.hour], from: detectDate, to: Date())
                                            return (components.hour ?? 0) > Int(day * 24)
                                        }
                                        return true
                                    }
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] value in
                self.shouldStartDetectApp.value = value
            })
            .disposed(by: self.disposeBag)
        
        
        self.shouldStartDetectApp.asObservable()
            .filter({ $0 == true })
            .subscribe(onNext: { [unowned self] _value in
                self.appInfoService()
            })
            .disposed(by: self.disposeBag)
        
        Observable.combineLatest(self.info.asObservable(),
                                 self.rx_skipDetectVersion.asObservable()) { (info, skipVersion) -> AppInfoResults? in
                                    if let _info = info, _info.shouldSkipThisVersion(skipVersion: skipVersion) {
                                        return nil
                                    }
                                    return info
            }
            .subscribe(onNext: { [unowned self] info in
                if let localVersion = Tools.getLocalVersion(), let itunesVersion = info?.version, Tools.compareVersion(localVersion, itunesVersion) {
                    self.configAppInfo(info: info)
                }
            })
            .disposed(by: self.disposeBag)
        
    }
    
    deinit { }
    
    private func configAppInfo(info: AppInfoResults?) {
        guard let _info = info else {
            return
        }
        
        let alertController = UIAlertController(title: _info.trackName, message: _info.releaseNotes, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "稍后再说", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "火速更新", style: .default, handler: { (action) in
            switch self.viewType() {
            case .inApp:
                self.openInApp(self.info.value)
            case .store:
                self.openInStore(self.info.value)
            }
        }))
        Tools.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - network
    
    private func appInfoService() {
        if let URL = self.urlForBundleID() {
            Alamofire.request(URL).responseObject { [unowned self] (response: DataResponse<AppInfoResponse>) in
                let infoResponse = response.result.value
                if infoResponse?.resultCount == 1, let resluts = infoResponse?.results {
                    self.info.value = resluts.first
                }
            }
        }
    }
    
    /** 更新时在APP应用内打开更新页面*/
    public func openInApp(_ info: AppInfoResults?) {
        guard let _info = info else {
            return
        }
        let storeVC = SKStoreProductViewController()
        storeVC.delegate = self
        storeVC.loadProduct(withParameters:[SKStoreProductParameterITunesItemIdentifier:_info.trackId ?? 0], completionBlock: { (loadFlag, error) in
            if !loadFlag {
                storeVC.dismiss(animated: true, completion: nil)
            }
        })
        Tools.rootViewController?.present(storeVC, animated: true, completion: nil)
    }
    
    /** 更新时跳转到Appstore页面*/
    public func openInStore(_ info: AppInfoResults?) {
        guard let _info = info else {
            return
        }
        DispatchQueue.main.async {
            UIApplication.shared.openURL(URL(string: _info.trackViewUrl ?? "")!)
        }
    }
    
}

// MARK: - actions

extension VersionKit {
    fileprivate func urlForBundleID() -> URL? {
        if let bundleID = self.delegate?.versionKitWithBundleID() {
            return URL(string: Constant.itunesURL + bundleID)
        }
        return nil
    }
    
    fileprivate func viewType() -> ViewAppType {
        if let delegate = self.delegate {
            return delegate.versionKitWithViewType()
        }
        return .inApp
    }
    
    public func reDetected() {
        self.reDetect.onNext(())
    }
}

// MARK: - VersionKitDelegate

public protocol VersionKitDelegate: class {
    /// 需要查询更新的bundleID
    ///
    /// - Returns: String
    func versionKitWithBundleID() -> String?
    
    /// /// 查看APP介绍页的方式
    ///
    /// - Returns: ViewAppType
    func versionKitWithViewType() -> ViewAppType
}

// MARK: -  SKStoreProductViewControllerDelegate

extension VersionKit: SKStoreProductViewControllerDelegate {
    public func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Constant

private struct Constant {
    /// itunes地址
    static let itunesURL = "http://itunes.apple.com/lookup?bundleId="
    /// 上一次检查的时间
    static let lastDetectTimeKey = "Version.LastDetectTime"
    /// 跳过检测的版本
    static let skipDetectVersionKey = "Version.SkipDetectVersion"
}
