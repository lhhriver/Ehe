# shutil

## shutil.copytree

```python
# 复制文件夹
shutil.copytree('py18\\1\\2\\','py18\\1\\3')
```

## shutil.copyfile

```python
# 要复制的文件必须是文件，新生成的可以是目标目录，也可以是目标文件
shutil.copyfile(file,"beifen.ipynb")
```

## shutil.move

```python
# 移动文件
shutil.move("beifen.ipynb",'py18\\1\\beifen.ipynb')
```

## shutil.rmtree

```python
# 删除目录
shutil.rmtree('py18') 
```

