//
//  main.swift
//  File Uploads
//
//  Created by Jonathan Guthrie on 2016-07-23.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectMustache

// Create HTTP server
let server = HTTPServer()

let handler = {
	(request: HTTPRequest, response: HTTPResponse) in

	let webRoot = request.documentRoot
	mustacheRequest(request: request, response: response, handler: UploadHandler(), templatePath: webRoot + "/response.mustache")
}

/// 访问服务器文档目录并返回给客户端一个图像文件
let imageHandler = {
    (request: HTTPRequest, response: HTTPResponse) in
    
    let docRoot = "./files"//request.documentRoot
    do {
        let mrPebbles = File("\(docRoot)/languages.png")
        let imageSize = mrPebbles.size
        let imageBytes = try mrPebbles.readSomeBytes(count: imageSize)
        response.setHeader(.contentType, value: MimeType.forExtension("jpg"))
        response.setHeader(.contentLength, value: "\(imageBytes.count)")
        response.setBody(bytes: imageBytes)
    } catch {
        response.status = .internalServerError
        response.setBody(string: "Request Error：\n \(error)")
    }
    response.completed()
}

// Add our routes
var routes = Routes()
routes.add(method: .post, uri: "/upload", handler: handler)
routes.add(method: .get, uri: "/image", handler: imageHandler)

server.addRoutes(routes)

// serve static content, including the index.html file
// remember to add files in ./webroot to the buildphase in xcode, to "copyfiles"
server.documentRoot = "./webroot"


// Set the listen port
server.serverPort = 8080


do {
    // Launch the server
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}
