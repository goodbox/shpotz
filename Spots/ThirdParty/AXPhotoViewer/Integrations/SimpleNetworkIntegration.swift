//
//  SimpleNetworkIntegration.swift
//  AXPhotoViewer
//
//  Created by Alex Hill on 6/11/17.
//  Copyright © 2017 Alex Hill. All rights reserved.
//

open class SimpleNetworkIntegration: NSObject, NetworkIntegrationProtocol, SimpleNetworkIntegrationURLSessionWrapperDelegate {
    
    fileprivate var urlSessionWrapper = SimpleNetworkIntegrationURLSessionWrapper()
    public weak var delegate: NetworkIntegrationDelegate?
    
    fileprivate var dataTasks = NSMapTable<PhotoProtocol, URLSessionDataTask>(keyOptions: .strongMemory, valueOptions: .strongMemory)
    fileprivate var photos = [Int: PhotoProtocol]()
    
    public override init() {
        super.init()
        self.urlSessionWrapper.delegate = self
    }
    
    deinit {
        self.urlSessionWrapper.invalidate()
    }
    
    public func loadPhoto(_ photo: PhotoProtocol) {
        if photo.imageData != nil || photo.image != nil {
            self.delegate?.networkIntegration(self, loadDidFinishWith: photo)
        }
        
        guard let url = photo.url else {
            return
        }
        
        let dataTask = self.urlSessionWrapper.dataDask(with: url)
        self.dataTasks.setObject(dataTask, forKey: photo)
        self.photos[dataTask.taskIdentifier] = photo
        dataTask.resume()
    }
    
    public func cancelLoad(for photo: PhotoProtocol) {
        guard let dataTask = self.dataTasks.object(forKey: photo) else {
            return
        }
        
        dataTask.cancel()
    }
    
    public func cancelAllLoads() {
        let enumerator = self.dataTasks.objectEnumerator()
        
        while let dataTask = enumerator?.nextObject() as? URLSessionDataTask {
            dataTask.cancel()
        }
        
        self.dataTasks.removeAllObjects()
        self.photos.removeAll()
    }
    
    // MARK: - SimpleNetworkIntegrationURLSessionWrapperDelegate
    fileprivate func urlSessionWrapper(_ urlSessionWrapper: SimpleNetworkIntegrationURLSessionWrapper,
                                       dataTask: URLSessionDataTask, 
                                       didUpdateProgress progress: CGFloat) {
        
        guard let photo = self.photos[dataTask.taskIdentifier] else {
            return
        }
        
        self.delegate?.networkIntegration?(self,
                                           didUpdateLoadingProgress: progress,
                                           for: photo)
    }
    
    fileprivate func urlSessionWrapper(_ urlSessionWrapper: SimpleNetworkIntegrationURLSessionWrapper,
                                       task: URLSessionTask,
                                       didCompleteWithError error: Error?,
                                       object: Any?) {
        
        guard let photo = self.photos[task.taskIdentifier] else {
            return
        }
        
        weak var weakSelf = self
        func removeDataTask() {
            self.photos.removeValue(forKey: task.taskIdentifier)
            self.dataTasks.removeObject(forKey: photo)
        }
        
        if let error = error {
            self.delegate?.networkIntegration(self, loadDidFailWith: error, for: photo)
            removeDataTask()
            return
        }
        
        guard let data = object as? Data else {
            return
        }
        
        if data.containsGIF() {
            photo.imageData = data
        } else {
            photo.image = UIImage(data: data)
        }
        
        removeDataTask()
        self.delegate?.networkIntegration(self, loadDidFinishWith: photo)
    }

}

// This wrapper abstracts the `URLSession` away from `SimpleNetworkIntegration` in order to prevent a retain cycle
// between the `URLSession` and its delegate
fileprivate class SimpleNetworkIntegrationURLSessionWrapper: NSObject, URLSessionDataDelegate, URLSessionTaskDelegate {
    
    weak var delegate: SimpleNetworkIntegrationURLSessionWrapperDelegate?
    
    fileprivate var urlSession: URLSession!
    fileprivate var receivedData = [Int: Data]()
    fileprivate var receivedContentLength = [Int: Int64]()
    
    override init() {
        super.init()
        self.urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
    
    func dataDask(with url: URL) -> URLSessionDataTask {
        return self.urlSession.dataTask(with: url)
    }
    
    func invalidate() {
        self.urlSession.invalidateAndCancel()
    }
    
    // MARK: - URLSessionDataDelegate
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.receivedData[dataTask.taskIdentifier]?.append(data)
        
        guard let receivedData = self.receivedData[dataTask.taskIdentifier],
            let expectedContentLength = self.receivedContentLength[dataTask.taskIdentifier] else {
            return
        }
        
        self.delegate?.urlSessionWrapper(self,
                                         dataTask: dataTask,
                                         didUpdateProgress: CGFloat(receivedData.count) / CGFloat(expectedContentLength))
    }

    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive response: URLResponse, 
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        self.receivedContentLength[dataTask.taskIdentifier] = response.expectedContentLength
        self.receivedData[dataTask.taskIdentifier] = Data()
        completionHandler(.allow)
    }
    
    // MARK: - URLSessionTaskDelegate
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        weak var weakSelf = self
        func removeData() {
            weakSelf?.receivedData.removeValue(forKey: task.taskIdentifier)
            weakSelf?.receivedContentLength.removeValue(forKey: task.taskIdentifier)
        }
        
        if let error = error {
            self.delegate?.urlSessionWrapper(self, task: task, didCompleteWithError: error, object: nil)
            removeData()
            return
        }
        
        guard let data = self.receivedData[task.taskIdentifier] else {
            self.delegate?.urlSessionWrapper(self, task: task, didCompleteWithError: nil, object: nil)
            removeData()
            return
        }
        
        self.delegate?.urlSessionWrapper(self, task: task, didCompleteWithError: nil, object: data)
        removeData()
    }
    
}

fileprivate protocol SimpleNetworkIntegrationURLSessionWrapperDelegate: NSObjectProtocol, AnyObject {
    
    func urlSessionWrapper(_ urlSessionWrapper: SimpleNetworkIntegrationURLSessionWrapper,
                           dataTask: URLSessionDataTask,
                           didUpdateProgress progress: CGFloat)
    func urlSessionWrapper(_ urlSessionWrapper: SimpleNetworkIntegrationURLSessionWrapper,
                           task: URLSessionTask,
                           didCompleteWithError error: Error?,
                           object: Any?)
    
}
