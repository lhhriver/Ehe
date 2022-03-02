# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     formats: ipynb,py:light
#     text_representation:
#       extension: .py
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.7.1
#   kernelspec:
#     display_name: Python 3
#     language: python
#     name: python3
# ---

import os 
import shutil
import time
import datetime

# # 文件夹整体迁移

# +
# path = r"D:\Gitee\NLP" 
# path = r"D:\Gitee\March\ML" 
# path = r"D:\Gitee\March\DL" 
# path = r"D:\Gitee\March\Python" 
# path = r"D:\Gitee\March\Base" 
# path = r"D:\Gitee\March\Math" 
# path = r"D:\Gitee\March\DA\数据分析笔记" 
# path = r"D:\Gitee\March\Java\Java_Basic_Introduction" 

path = r"D:\Gitee\DDU\NLP"
path_images = r"D:\Gitee\Ehe\images" # 目标图片文件夹
# -

# ## 读取图片改名信息

import json
file_json = r'images_dt.json'
with open(file_json, 'r', encoding='utf-8') as f:
    images_dt = json.load(f)

# +
# images_dt
# -

# ## 生成图片改名信息及迁移

# +
for root, dirs, files in os.walk(path):
    images_dt.setdefault(root, {})  # 文件夹路径

    if os.path.basename(root) == 'images':
        for file in files:
            time.sleep(0.001)  # 防止图片重名
            # 图片文件夹
            if file not in images_dt[os.path.dirname(root)]:
                print(">>> ", root, file)
                # 目标图片名
                image_name = os.path.basename(
                    os.path.dirname(root)) + "-" + datetime.datetime.now(
                    ).strftime("%Y%m%d-%H%M%S-%f") + os.path.splitext(file)[-1]
                
                images_dt[os.path.dirname(root)][file] = image_name  # 保存图片改名信息

                # 复制图片到指定文件夹，并重新命名
                shutil.copyfile(os.path.join(root, file),
                                os.path.join(path_images, image_name))
                
images_dt = {k: v for k, v in images_dt.items() if v}
# images_dt

# +
# for key in images_dt.keys():
#     print('\n',key,">>>")
#     for k, v in images_dt[key].items():
#         print("\t", k,'-->', v)
# -

# ## MD文件迁移

# +
# 复制md文件

# for root, dirs, files in os.walk(path):
#     root_new = root.replace(path, path_obj) # 目标文件夹路径

#     for file in files:
#         # MD文件
#         if os.path.splitext(file)[-1] == ".md" and file not in ['_contents.md']:
#             if not os.path.exists(root_new): 
#                 # 新建目标文件夹
#                 os.makedirs(root_new)
                
#             print(os.path.join(root, file), '>>>', os.path.join(root_new, file))
#             shutil.copyfile(os.path.join(root, file), os.path.join(root_new, file))
# -

# ## 修改图片插入来源

# 修改图片插入信息
for root, dirs, files in os.walk(path):
    if os.path.basename(root) not in ['.ipynb_checkpoints']:
        for file in files:
            if os.path.splitext(file)[-1] == ".md":
                file_path = os.path.join(root, file)

                string_all = open(file_path, 'r', encoding='utf-8').readlines()

                for i in range(len(string_all)):
                    if 'images' in string_all[
                            i] and 'liuhuihe' not in string_all[i]:
                        tmp_str = string_all[i]
                        
                        if "]" in tmp_str:
                            N1, N2 = tmp_str.find("!["), tmp_str.find(")")
                            obg_str = tmp_str[N1:N2 + 1]
                            N = obg_str.find("images/") + 7
                            images_name = obg_str[N:-1]
                            tmp_str = tmp_str[:
                                              N1] + "![](images/" + images_name + ")" + tmp_str[
                                                  N2 + 1:]

                        if "<" in tmp_str:
                            N1, N2 = tmp_str.find("<"), tmp_str.find(">")
                            obg_str = tmp_str[N1:N2 + 1].replace('"', " ")
                            N = obg_str.find("images/") + 7
                            images_name = obg_str[N:obg_str.find(" ", N)]
                            tmp_str = tmp_str[:
                                              N1] + "![](images/" + images_name + ")" + tmp_str[
                                                  N2 + 1:]

                        try:
                            if images_name in images_dt[root]:
                                # 替换图片名
                                tmp_str = tmp_str.replace(
                                    images_name, images_dt[root][images_name])
                                # 替换图片来源
                                tmp_str = tmp_str.replace(
                                    './images', 'images'
                                ).replace(
                                    'images/',
                                    'https://gitee.com/liuhuihe/Ehe/raw/master/images/'
                                )
                                string_all[i] = tmp_str
                        except Exception as e:
                            print(e)
                            print(root, file)
                            print(">>>", tmp_str)

                open(file_path, 'w', encoding='utf-8').writelines(string_all)

# ## 图片改名信息存入本地

# +
import json

images_js = json.dumps(images_dt, indent=4)
with open(file_json, 'w', encoding='utf-8') as f:
    f.write(images_js)
# -


