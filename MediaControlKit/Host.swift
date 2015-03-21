//
//  Host.swift
//  MediaControlKit
//
//  Created by Joel Angelone on 2/27/15.
//  Copyright (c) 2015 Draken Design. All rights reserved.
//

import UIKit

public class Host: NSObject {
    private var hostName: String
    private var port: Int
    
    private var outputStream: NSOutputStream?
    private var inputStream: NSInputStream?
    
    private var socketQueue: dispatch_queue_t
    
    init(hostName: String, port: Int) {
        self.hostName = hostName
        self.port = port
        
        let queueName = "com.draken.MediaControl.HostQueue.\(hostName):\(port)"
        let queueAtrributes = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INTERACTIVE, 0)
        
        socketQueue = dispatch_queue_create(queueName, queueAtrributes)
    }
    
    private func connect() {
        if outputStream == nil {
            NSStream.getStreamsToHostWithName(hostName, port: port, inputStream: &inputStream, outputStream: &outputStream)
            
            outputStream?.open()
        }
    }
    
    func sendMessage(message: String) {
        dispatch_async(socketQueue, { () -> Void in
            self.connect()
            
            if let encodedMessage = message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                self.outputStream?.write(UnsafePointer<UInt8>(encodedMessage.bytes), maxLength: encodedMessage.length)
            }
        })
    }

    func disconnect() {
        outputStream?.close()
        outputStream = nil
    }
}
