import Foundation

var app_key: String = "eI3RKs1oSBSY2kReFnviIw"
var app_secret = "Gv9DgBZVTkaQNbbyEx-SQQBsnUKECmT5GrmGXbHTmpUQ"
var username = "13464448343"
var password = "P@ssw0rd"

var rcsdk = SDK(appKey: app_key, appSecret: app_secret, server: SDK.RC_SERVER_SANDBOX)
var platform = rcsdk.getPlatform()
platform.authorize(username, password: password)
//platform.testSubCall()
platform.testApiCall2()
sleep(5)