
#!/usr/bin/python
# coding: utf-8 -*-





import sys
import json
import re

import yql
import photo
import user_info
import yql_function

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



if __name__ == '__main__':
    
    
    main()
    
    print "done it"