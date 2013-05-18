#!/usr/bin/python
# -*- coding: utf-8 -*-


import sys
import json
import re

import yql
import photo
import user_info
import yql_function



def get_dict(user_dict ,photo_dict):
    f_user = open('user','r')
    f_photo = open('photo','r')
    
    
    json_user = json.loads(f_user.read())
    
    for each_user in json_user:
        print each_user
        id = each_user['user']
        user_dict[id] = user_info.userData()
        user_dict[id].id = id
        for each in  each_user['selfimg']:
            user_dict[id].selfimg.add(each)
        
    
        for each in  each_user['favimg']:
            user_dict[id].favimg.add(each)
        print type (each_user['taginfo'] )
        user_dict[id].taginfo  = each_user['taginfo']
        

    
    json_photo =  json.loads(f_photo.read())
    for each_photo in json_photo:
        id = each_photo['id']
        photo_dict[id] = photo.photoData()
        photo_dict[id].id = id
        
        photo_dict[id].subject  = each_photo['subject']
        photo_dict[id].taginfo   = each_photo['taginfo']
        photo_dict[id].width = each_photo['width'] 
        photo_dict[id].height = each_photo['height']
        photo_dict[id].source = each_photo['source']
        photo_dict[id].title = each_photo['title'] 

user_dict = {}
photo_dict = {}
get_dict(user_dict ,photo_dict)

for each in user_dict:
    print user_dict[each].id
print "done"
