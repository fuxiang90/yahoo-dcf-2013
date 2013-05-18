#!/usr/bin/python
# coding: utf-8 -*-





import sys
import json
import re

import yql
import photo
import user_info
import yql_function


def check_json_dict():
    
    user_dict = {}
    user_dict['1'] = user_info.userData()
    user_dict['1'].id = '1'
    f_user = open('user','w')

    
    
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

if __name__ == '__main__':
    check_json_dict()
    
    print "done it"