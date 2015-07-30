//
//  NSURLSession+Rx.swift
//  RxCocoa
//
//  Created by Krunoslav Zaher on 3/23/15.
//  Copyright (c) 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation
import RxSwift

func escapeTerminalString(value: String) -> String {
    return value.stringByReplacingOccurrencesOfString("\"", withString: "\\\"", options:[], range: nil)
}

func convertURLRequestToCurlCommand(request: NSURLRequest) -> String {
    let method = request.HTTPMethod ?? "GET"
    var returnValue = "curl -i -v -X \(method) "
        
    if  request.HTTPMethod == "POST" && request.HTTPBody != nil {
        let maybeBody = NSString(data: request.HTTPBody!, encoding: NSUTF8StringEncoding) as? String
        if let body = maybeBody {
            returnValue += "-d \"\(body)\""
        }
    }
    
    for (key, value) in request.allHTTPHeaderFields ?? [:] {
        let escapedKey = escapeTerminalString((key as String) ?? "")
        let escapedValue = escapeTerminalString((value as String) ?? "")
        returnValue += "-H \"\(escapedKey): \(escapedValue)\" "
    }
    
    let URLString = request.URL?.absoluteString ?? "<unkown url>"
    
    returnValue += "\"\(escapeTerminalString(URLString))\""
    
    return returnValue
}

func convertResponseToString(data: NSData!, _ response: NSURLResponse!, _ error: NSError!, _ interval: NSTimeInterval) -> String {
    let ms = Int(interval * 1000)
    
    if let response = response as? NSHTTPURLResponse {
        if 200 ..< 300 ~= response.statusCode {
            return "Success (\(ms)ms): Status \(response.statusCode)"
        }
        else {
            return "Failure (\(ms)ms): Status \(response.statusCode)"
        }
    }

    if let error = error {
        if error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
            return "Cancelled (\(ms)ms)"
        }
        return "Failure (\(ms)ms): NSError > \(error)"
    }
    
    return "<Unhandled response from server>"
}

extension NSURLSession {
    public func rx_response(request: NSURLRequest) -> Observable<(NSData!, NSURLResponse!)> {
        return create { observer in
            
            // smart compiler should be able to optimize this out
            var d: NSDate!
            
            if Logging.URLRequests {
                d = NSDate()
            }
            
            let task = self.dataTaskWithRequest(request) { (data, response, error) in
                
                if Logging.URLRequests {
                    let interval = NSDate().timeIntervalSinceDate(d)
                    print(convertURLRequestToCurlCommand(request))
                    print(convertResponseToString(data, response, error, interval))
                }
                
                if data == nil || response == nil {
                    sendError(observer, error ?? UnknownError)
                }
                else {
                    sendNext(observer, (data, response))
                    sendCompleted(observer)
                }
            }
            
            
            let t = task
            t.resume()            
                
            return AnonymousDisposable {
                task.cancel()
            }
        }
    }
    
    public func rx_data(request: NSURLRequest) -> Observable<NSData> {
        return rx_response(request) >- mapOrDie { (data, response) -> RxResult<NSData> in
            if let response = response as? NSHTTPURLResponse {
                if 200 ..< 300 ~= response.statusCode {
                    return success(data!)
                }
                else {
                    return failure(rxError(.NetworkError, message: "Server returned failure", userInfo: [RxCocoaErrorHTTPResponseKey: response]))
                }
            }
            else {
                rxFatalError("response = nil")
                
                return failure(UnknownError)
            }
        }
    }
    
    public func rx_JSON(request: NSURLRequest) -> Observable<AnyObject!> {
        return rx_data(request) >- mapOrDie { (data) -> RxResult<AnyObject!> in
            do {
              let result = try NSJSONSerialization.JSONObjectWithData(data, options: [])
              return success(result)
            }
            catch let caught as NSError  {
                return failure(caught)
            }
            catch {
                return failure(UnknownError)
            }
            
        }
    }
    
    public func rx_JSON(URL: NSURL) -> Observable<AnyObject!> {
        return rx_JSON(NSURLRequest(URL: URL))
    }
}