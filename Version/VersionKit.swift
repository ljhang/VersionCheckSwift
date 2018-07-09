//
//  VersionKit.swift
//  Version
//
//  Created by 李建航 on 2018/7/6.
//  Copyright © 2018 lee. All rights reserved.
//

import Foundation
import RxSwift
import Reachability
import AlamofireObjectMapper
import Alamofire

public class VersionKit {
    
    public static let shareInstance = VersionKit()
    
    public static let bundle = Bundle(for: VersionKit.self)
    
    public weak var delegate: VersionKitDelegate?
    
    /// 上次检查时间
    let lastCheckTime: Variable<String?> = Variable(UserDefaults.standard.string(forKey: Constant.lastCheckTimeKey))
    
    private let reachability = Reachability()
    
    private let disposeBag = DisposeBag()
    
    private init() {
        
        Observable.just(())
            .delay(5.0, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] _ in
                self.startReachability()
            })
            .disposed(by: self.disposeBag)
        
        
        
        if let version = Tools.getLocalVersion(), Tools.compareVersion(version, "1.0.6") {
            print("yes")
        } else {
            print("no")
        }
    
    }
    
    deinit {
        self.reachability?.stopNotifier()
    }
    
    // MARK: - network
    
    private func startReachability() {
        self.reachability?.whenReachable = { [weak self] _ in
            self?.requestIfNeeded()
        }
        try? self.reachability?.startNotifier()
    }
    
    private func requestIfNeeded() {
        print("发起请求")
        
        self.appInfoService()
    }
    
    
    private func appInfoService() {
        if let URL = self.urlForBundleID() {
            Alamofire.request(URL).responseObject { (response: DataResponse<AppInfoResponse>) in
                let infoResponse = response.result.value
                print("infoResponse - \(infoResponse.debugDescription)")
                if let resluts = infoResponse?.results {
                    print("resluts - \(resluts.debugDescription)")
                }
            }
        }
    }
}

// MARK: - URLs

extension VersionKit {
    func urlForBundleID() -> URL? {
        if let bundleID = self.delegate?.versionKitWithBundleID() {
            return URL(string: Constant.itunesURL + bundleID)
        }
        return nil
    }
}

// MARK: - VersionKitDelegate

public protocol VersionKitDelegate: class {
    func versionKitWithBundleID() -> String?
}



// MARK: - Constant

private struct Constant {
    /// itunes地址
    static let itunesURL = "http://itunes.apple.com/lookup?bundleId="
    /// 上一次检查的时间
    static let lastCheckTimeKey = "Version.LastCheckTime"
    
}
