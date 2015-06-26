import Foundation

var app_key: String = "eI3RKs1oSBSY2kReFnviIw"
var app_secret = "Gv9DgBZVTkaQNbbyEx-SQQBsnUKECmT5GrmGXbHTmpUQ"
var username = "13464448343"
//var ext = "102"
var password = "P@ssw0rd"


var rcsdk = Sdk(appKey: app_key, appSecret: app_secret, server: Sdk.RC_SERVER_SANDBOX)

var platform = rcsdk.getPlatform()

platform.authorize(username, password: password)
println(platform.auth!.getAccessToken())
sleep(2)
platform.test7()


//usleep(2000000)
//
//println(platform.getAccountInfo())
//
//sleep(2)
//
//println()
//println("Access Token: " + platform.auth!.access_token!)
//println()
//println("Refresh Token: " + platform.auth!.refresh_token!)
//println()
//println("Authenticated: " + platform.auth!.authenticated.description)
//println()
//println("Expires in: " + platform.auth!.expires_in.description)
//println()
//println("Refresh expires in: " + platform.auth!.refresh_token_expires_in.description)
//println()
//println("Expire time: " + platform.auth!.expire_time.description)
//println()
//println("Refresh expire time: " + platform.auth!.refresh_token_expire_time.description)
//println()
//
//sleep(1)
//
//platform.refresh()
//usleep(2000000)
//println()
//println("Access Token: " + platform.auth!.access_token!)
//println()
//println("Refresh Token: " + platform.auth!.refresh_token!)
//println()
//println("Expires in: " + platform.auth!.expires_in.description)
//println()
//println("Refresh expires in: " + platform.auth!.refresh_token_expires_in.description)
//println()
//println("Expire time: " + platform.auth!.expire_time.description)
//println()
//println("Refresh expire time: " + platform.auth!.refresh_token_expire_time.description)
//println()
//
//sleep(1)
//
//platform.logout()
//
//sleep(1)
//
println(platform.version)
//
//sleep(1)

// MUST WAIT FOR RESPONSE to receive data/response/error





