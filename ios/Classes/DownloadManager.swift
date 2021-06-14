//
//  DownloadManager.swift
//  file_view_pager
//
//  Created by tungnd on 6/10/21.
//

import Foundation

class DownloadManager {
    
    func downloadFile(url: String, result: @escaping (Bool) -> ()) {
        if (url.isImage) {
            getData(from: URL(string: url)!) { data, response, error in
                guard let data = data, error == nil else {
                    result(false)
                    return
                }
                DispatchQueue.main.async() { [] in
                    guard let uiImage = UIImage(data: data) else {
                        result(false)
                        return
                    }
                    UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
                    result(true)
                }
            }
        } else {
            saveDocuments(urlString: url) {resultSaveFile in
                result(resultSaveFile)
            }
        }
        
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    private func saveDocuments(urlString: String, callback: @escaping (Bool) -> ()) {
        if #available(iOS 11.0, *) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                let url = URL(string: urlString)
                var urlData: Data? = nil
                guard let urlCheckNull = url else {
                    callback(false)
                    return
                }
                
                do {
                    urlData = try Data(contentsOf: urlCheckNull)
                }
                catch {
                    callback(false)
                    return
                }
                if let urlData = urlData {
                    self.savePDF(data: urlData)
                    callback(true)
                } else {
                    callback(false)
                }
            })
        } else {
            // Fallback on earlier versions
            showAlert(message: "Vui lòng cập nhật iOS để sử dụng tính năng này")
            callback(false)
        }
    }
    
    @available(iOS 11.0, *)
    func savePDF(data: Data) {
        let activityViewController = UIActivityViewController(activityItems: ["File from CyHome", data], applicationActivities: nil)
        activityViewController.modalPresentationStyle = .fullScreen
        if !(UIApplication.topViewController() is UIAlertController) {
            UIApplication.topViewController()!.present(activityViewController, animated: true, completion: nil)
        }
        //        UIApplication.shared.present(activityViewController, animated: true, completion: nil)
    }
    
    func showAlert(title: String? = nil, message: String?, cancelAction: (()->())? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if #available(iOS 13.0, *) {
            alertVC.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
            cancelAction?()
        }))
        if !(UIApplication.topViewController() is UIAlertController) {
            UIApplication.topViewController()!.present(alertVC, animated: true, completion: nil)
        }
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        
        return controller
    }
}

extension String {
    var isImage: Bool {
        return self.contains(".png") || self.contains(".jpg") || self.contains(".jpeg")
    }
    
    var isDriveFile: Bool {
        return self.contains(".doc") || self.contains(".xlxs") || self.contains(".pdf")
    }
}
