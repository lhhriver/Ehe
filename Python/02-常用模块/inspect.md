

# inspect

　　通过 inspect 模块查看 add() 函数的源代码：

```python
def add(x, y=10):
  return x + y
  
from inspect import getsource

print(getsource(add))
```

