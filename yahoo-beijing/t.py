#!/usr/bin/python
# -*- coding: utf-8 -*-


import urllib
import urllib2
import sys
import json
import re

import yql
import photo
import user_info
api_key = "77f1cc3b101c84e5c2694ff1ab73172b"

def get_json_flickr_yql(subject ):
 
    query_str = 'select * from flickr.photos.sizes where photo_id in (select id from flickr.photos.search where text=@text  and api_key=@api_key limit 100) and api_key =@api_key' 

    y = yql.Public() 
#     query = 'select * from flickr.photos.search where text=@text and api_key="77f1cc3b101c84e5c2694ff1ab73172b" limit 3';
    l = y.execute(query_str , {"text":subject ,"api_key":api_key})
    
    
    return l.rows
#     print json_str

def get_url_photo_id(url_str):
    """
    "http://www.flickr.com/photos/63028919@N07/8731761170/sizes/t/"
    """
    print url_str
               
    pattern = re.compile(r'(^<=[/]).*?(?=[/sizes])')#.*\/(\d*)\/size') 
    
    pattern = re.compile(r'.*[/](\d*)[/].*')
    m = pattern.findall(url_str)
    
    if m :
        return m
    else :
        return 0
    
def get_json_flickr_yal_all(photo_dict ):
    
    subjects = ['supermaket' ,'girls']
    
    for subject in subjects:
        d = get_json_flickr_yql(subject)
        
        for each in d:
            photo_id = get_url_photo_id(each['url'])
            photo_data  = photo.photoData(each)
            if photo_id not in photo_dict:
                photo_dict[photo_id] = photo_data
            photo_dict.id = photo_id
                
                

"""
通过组 得到一系列的userid 
SELECT * FROM flickr.groups.pools.photos WHERE group_id='22637658@N00' AND extras='url_sq' and api_key = "77f1cc3b101c84e5c2694ff1ab73172b"
"""
def get_json_groub_user_id(groub_str):   
        
    query_str =' SELECT * FROM flickr.groups.pools.photos WHERE group_id=@groub AND extras="url_sq" and api_key =@api_key '
    y = yql.Public() 
    l = y.execute(query_str , {"groub":groub_str ,"api_key":api_key})
    
    print l.rows
    return l.rows        

def get_json_groub_user_id_all(user_dict):
    groubs = ['22637658@N00']  
    for groub in groubs :
        d =   get_json_groub_user_id(groub)
        for each in d:
            user_id = each['owner']
            if user_id not in user_dict:
                user_dict[user_id] = user_info.userData()
                user_dict[user_id].id = user_id
    

def get_photo_id_by_user_id(userid):
    
    query_str = 'SELECT * FROM flickr.people.publicphotos(0,50) WHERE user_id=@userid AND extras="url_sq" and api_key =@api_key '
    y = yql.Public() 
    l = y.execute(query_str , {"userid":userid ,"api_key":api_key})
    
#     print l.rows
    return l.rows 

def get_photo_id_by_user_id_all(photo_dict ,user_dict):
    
    for each_user in user_dict:
        print each_user
        d = get_photo_id_by_user_id(user_dict[each_user].id)
        for each in d:
            title = each['title']
            photo_id = each['id']
            if photo_id not in photo_dict:
                photo_dict[photo_id]  = photo.photoData()
                photo_dict[photo_id].title = title
                photo_dict[photo_id].width = each['width_sq']
                photo_dict[photo_id].height = each['height_sq']
                photo_dict[photo_id].source =each['url_sq']
    
def get_taginfo_by_photo_id(photoid):
	query_str = 'select * from flickr.photos.info where photo_id=@photoid and api_key = @api_key'
    y = yql.Public() 
    l = y.execute(query_str , {"photoid":photoid ,"api_key":api_key})
    
#     print l.rows
    return l.rows   
      
if __name__  == '__main__':
    
    d = {}
#     get_json_flickr_yal_all(d)
#     get_json_groub_user_id_all(d)
    get_photo_id_by_user_id('68701427@N05')
    
    print len(d.keys())
    print "done it"
