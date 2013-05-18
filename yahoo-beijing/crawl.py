
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
    
    f_user.write(json.dumps(user_dict))
    f_photo.write(json.dumps(photo_dict))
    
    
def main():
    user_dict = {}
    
    photo_dict = {}
    yql_function.get_json_groub_user_id_all(user_dict)
    
    print user_dict
    yql_function.get_photo_id_by_user_id_all(photo_dict ,user_dict)
    
    yql_function.get_taginfo_by_photo_id_all(user_dict, photo_dict)

        
    print len(photo_dict) 
    print len(user_dict)
    store_dict(user_dict ,photo_dict)



if __name__ == '__main__':
    
    
    main()
    
    print "done it"