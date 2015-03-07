//
//  Job.swift
//  JobSearch
//
//  Created by Gelei Chen on 15/3/7.
//  Copyright (c) 2015年 Purdue Bang. All rights reserved.
//

import Foundation

class Job:NSObject{
    var longitude: Double
    var latitude : Double
    var salary : String
    var title : String
    
    
    
    
    
    init(longitude:Double,latitude:Double,salary:String,title:String){
        self.longitude = longitude
        self.latitude = latitude
        self.salary = salary
        self.title = title
        
    }
}