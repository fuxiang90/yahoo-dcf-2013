
#!/usr/bin/python
# -*- coding: utf-8 -*-





import sys
import json
import re
import urllib2

import yql
import photo
import user_info
import yql_function

api_key = "77f1cc3b101c84e5c2694ff1ab73172b"

def get_photo_id_by_user_id(user_dict):
    
    
    pass

def store_dict(user_dict ,photo_dict):
    f_user = open('user','w')
    f_photo = open('photo','w')
    
    
    json_user = []
    for each_user in user_dict:
        d = {}
        d['user'] = each_user
        d['selfimg'] = []
        for each in  user_dict[each_user].selfimg:
            d['selfimg'].append(each)
        
        d['favimg'] = []
        for each in  user_dict[each_user].favimg:
            d['favimg'].append(each)
            
        d['taginfo'] = user_dict[each_user].taginfo
        
        d['name'] = user_dict[each_user].name
        
        d['source'] = user_dict[each_user].source
        json_user.append(d)
        
    f_user.write(json.dumps(json_user)) 
    
    f_user.close()
    
    json_photo = []
    for each_photo in photo_dict:
        d = {}
        d['id'] = each_photo
        
        d['subject']  = photo_dict[each_photo].subject
        d['taginfo']  = photo_dict[each_photo].taginfo
        d['width'] = photo_dict[each_photo].width 
        d['height'] = photo_dict[each_photo].height
        d['source'] = photo_dict[each_photo].source
        d['title'] = photo_dict[each_photo].title 
        json_photo.append(d)

        
    f_photo.write(json.dumps(json_photo)) 
    f_photo.close()


def get_dict(user_dict ,photo_dict):
    f_user = open('user','r')
    f_photo = open('photo','r')
    
    
    json_user = json.loads(f_user.read())
    
    for each_user in json_user:
#         print each_user
        id = each_user['user']
        user_dict[id] = user_info.userData()
        user_dict[id].id = id
        for each in  each_user['selfimg']:
            user_dict[id].selfimg.add(each)
        
    
        for each in  each_user['favimg']:
            user_dict[id].favimg.add(each)
#         print type (each_user['taginfo'] )
        user_dict[id].taginfo  = each_user['taginfo']
        if 'name' in each_user:
            user_dict[id].name=  each_user['name']
#             print each_user['name']
        if 'source' in each_user:
            user_dict[id].source = each_user['source']
    
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

 


def get_user_love_photo_id(user_id):
    """
     http://api.flickr.com/services/rest/?method=flickr.favorites.getPublicList&api_key=da70bd4a798859938ddaa25602b1af33&user_id=9372156%40N04&format=json&nojsoncallback=1
    """ 
    query_str =   'http://api.flickr.com/services/rest/?method=flickr.favorites.getPublicList&api_key=' + api_key +'&user_id=' +user_id +'&format=json&nojsoncallback=1'
#     print query_str
    html = urllib2.urlopen(query_str).read()
#     print html
    json_html = json.loads(html)
    photo_list = []
#     print json_html
    for each in json_html['photos']['photo']:
#         print each['id']
        photo_list.append(each['id'])
    
    return photo_list

def get_user_love_photo_id_all(user_dict  ,photo_dict):
    
    pos = 0
    for each_user in user_dict:
        l = get_user_love_photo_id(each_user)
        if len(l) > 10:
            l = l[:10]
        user_dict[each_user].favimg = set (l  )
        
        for each_photo_id in user_dict[each_user].favimg:
            
#             print "len "+str(len(user_dict[each_user].favimg))
            if True or each_photo_id not in photo_dict:
                yql_function.get_photo_info_by_url(each_photo_id , photo_dict)
                if pos % 10 == 0:
                    print pos 
                if pos >= 3000 :
                    continue
                pos = pos +1
 
def get_photo_source(photo_dict ,user_dict):
    
    for each_photo in photo_dict :
        yql_function.get_photo_info_by_url(each_photo , photo_dict)  
    for each_user in user_dict :
        favimg = user_dict[each_user].favimg   
        for each in favimg:
            yql_function.get_photo_info_by_url(each , photo_dict)          
def main():
    user_dict = {}
    
    photo_dict = {}
    yql_function.get_json_groub_user_id_all(user_dict)
    
#     print user_dict
    yql_function.get_photo_id_by_user_id_all(photo_dict ,user_dict)
    store_dict(user_dict ,photo_dict)
    yql_function.get_taginfo_by_photo_id_all(user_dict, photo_dict)

        
    print len(photo_dict) 
    print len(user_dict)
#     store_dict(user_dict ,photo_dict)



def user_main():
    user_dict = {}
     
    photo_dict = {}

    
    get_dict(user_dict, photo_dict)

    print len(user_dict)
    yql_function.get_all_user_name_info(user_dict)
    
#     get_user_love_photo_id_all(user_dict  ,photo_dict)
    
    store_dict(user_dict ,photo_dict)
    

if __name__ == '__main__':
    
    user_main()
#     main()
    
    print "done it"