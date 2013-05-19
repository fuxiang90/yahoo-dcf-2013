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
import crawl
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
#     print url_str
               
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
    
#     print l.rows
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
    

    return l.rows  

"""
这里也把 user 和 photo 的taginfo  赋值
"""
def get_taginfo_by_photo_id_all(user_dict ,photo_dict):
    
    ###debug
    
#     photo_dict['8714694455'] = photo.photoData()
#     photo_dict['8714694455'].id = "8714694455"
#     
#     photo_dict['8747460606'] = photo.photoData()
#     photo_dict['8747460606'].id = "8747460606"
 
    ### end debug
    
    for photo_id in photo_dict:
        d = get_taginfo_by_photo_id(photo_id)
#         print photo_id
        if len(d[0]) == 0 :
            continue
        if type(d[0]['tags']) is None :
            continue
#         print d[0]
#         print d[0]['tags']
        
        if isinstance(d[0]['tags'] ,list ) == False and isinstance(d[0]['tags'] ,dict ) == False:
            continue
        tags = d[0]['tags']['tag']
#         print type(tags)
        """
            一个坑 ，如果 tag 只有一个 那么 直接是 dict 的类型
        """
#         print type(tags)
        if isinstance(tags ,list):
            
            for tag in tags:
                tag_name = tag['content']
                user_id = tag['author']
            
                if tag_name not in photo_dict[photo_id].taginfo:
                    photo_dict[photo_id].taginfo[tag_name] = []
                    photo_dict[photo_id].taginfo[tag_name].append(user_id)
                if user_id not in user_dict:
                    user_dict[user_id] = user_info.userData()
                    user_dict[user_id].id = user_id
                if tag_name not in user_dict[user_id].taginfo:
                    user_dict[user_id].taginfo[tag_name] = 0
                user_dict[user_id].taginfo[tag_name] = user_dict[user_id].taginfo[tag_name] + 1
        elif isinstance(tags ,dict):
            tag_name = tags['content']
            user_id = tags['author']
            
            if tag_name not in photo_dict[photo_id].taginfo:
                photo_dict[photo_id].taginfo[tag_name] = []
                photo_dict[photo_id].taginfo[tag_name].append(user_id)
            if user_id not in user_dict:
                user_dict[user_id] = user_info.userData()
                user_dict[user_id].id = user_id
            if tag_name not in user_dict[user_id].taginfo:
                user_dict[user_id].taginfo[tag_name] = 0
            user_dict[user_id].taginfo[tag_name] = user_dict[user_id].taginfo[tag_name] + 1

"""
用url的方式得到
http://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=ce066b8ce6f18f84143bded95a3a4f8a&photo_id=8670010354&format=json&nojsoncallback=1
"""
def get_photo_info_by_url(photo_id ,photo_dict):
    
    if photo_id in photo_dict and  photo_dict[photo_id].source != "":
        return 
    photo_dict[photo_id] = photo.photoData()
    
    photo_dict[photo_id].id  =  photo_id
    
    query_str =   'http://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=' + api_key +'&photo_id=' +photo_id +'&format=json&nojsoncallback=1'
#     print query_str
    html = urllib2.urlopen(query_str).read()
#     print html
    json_html = json.loads(html)

#     print json_html
    photo_dict[photo_id].title =  json_html['photo']['title']['_content']
#    
    query_str2 = 'http://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key='+api_key+'&photo_id='+photo_id +'&format=json&nojsoncallback=1'
    html = urllib2.urlopen(query_str2).read()
#     print html
    json_html = json.loads(html) 
    
    photo_dict[photo_id].source = json_html['sizes']['size'][1]['source']
    photo_dict[photo_id].width = 150
    photo_dict[photo_id].heigth = 150
    

def get_all_interest(interest_photo):
    
    
    query = 'http://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key='+api_key+'&format=json&nojsoncallback=1'
    html = urllib2.urlopen(query).read()
#     print html
    json_html = json.loads(html) 
    l = json_html['photos']['photo']
    
    for each in l:
        id = str(each['id'])
        interest_photo[id] = photo.photoData()
        interest_photo[id].id = id
        source = 'http://farm'+str(each['farm'])+'.staticflickr.com/'+each['server']+'/'+id+'_'+each['secret']+'_q.jpg'
#         print source
        interest_photo[id].source = source
        interest_photo[id].width = 150
        interest_photo[id].heigth = 150
        interest_photo[id].title = each['title']

def get_user_name_info(userid):
    """
    SELECT * FROM flickr.people.info2 WHERE user_id='51035801340@N01' and api_key = "77f1cc3b101c84e5c2694ff1ab73172b"
    """
    query_str = 'SELECT * FROM flickr.people.info2 WHERE user_id=@user_id and api_key =@api_key '
    y = yql.Public() 
    l = y.execute(query_str , {"user_id":userid ,"api_key":api_key})
    

    return l.rows  
def get_all_user_name_info(user_dict):
    for user in user_dict :
        d =  get_user_name_info(user)
        if len(d) == 0:
            continue 
        d = d[0]
#         print user
        user_dict[user].name = d['username']
        user_dict[user].source = d['buddyiconurl']
        
if __name__  == '__main__':
    
    user_dict = {}
    photo_dict = {}
    crawl.get_dict(user_dict, photo_dict)
    get_all_user_name_info(user_dict)
    crawl.store_dict(user_dict, photo_dict)
    
#     get_all_interest()
#     get_taginfo_by_photo_id_all(d ,dd)
#     get_json_flickr_yal_all(d)
#     get_json_groub_user_id_all(d)
#     get_photo_id_by_user_id('68701427@N05')
# 
#     get_photo_info_by_url('8670010354',d)
#     dd = get_taginfo_by_photo_id("8717078981")
#    
#     print type(dd[0]['tags'] )
#     
#     if isinstance(dd[0]['tags'] ,list ) == False and isinstance(dd[0]['tags'] ,dict ) == False:
#         print "Yes"
#     tags =  dd[0]['tags']['tag']
#     print dd[0]
#     print dd[0]['tags']['tag']
#     print type(tags) 
# #     tags_dict = json.loads(tags)
#     tags_dict = tags
#      
#     print tags['content']
#     
    print "done it"