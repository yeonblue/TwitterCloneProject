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
