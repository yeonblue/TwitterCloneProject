//
//  Constants.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/07.
//

import Firebase
import UIKit

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")
let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_TWEETS = DB_REF.child("tweets")

let REF_USER_TWEET = DB_REF.child("user-tweets")
let REF_USER_FOLLOWERS = DB_REF.child("user-followers")
let REF_USER_FOLLOWING = DB_REF.child("user-following")
let REF_TWEET_REPLIES = DB_REF.child("tweet-replies")
let REF_USER_LIKES = DB_REF.child("user-likes")

let REF_TWEET_LIKES = DB_REF.child("tweet-likes")
let REF_NOTIFICATION = DB_REF.child("notifications")
let REF_USER_REFLIES = DB_REF.child("user-replies")
let REF_USER_USERNAMES = DB_REF.child("user-usernames")
