

# decimal


```python
# Decimal模块：小数模块
import decimal
from decimal import Decimal
Decimal("0.01") + Decimal("0.02")  # 返回Decimal("0.03")
```


    Decimal('0.03')


```python
decimal.getcontext().prec = 4  # 设置全局精度为4 即小数点后边4位
```

