# collections


```python
import collections
```


```python
li = [i for i in dir(collections) if not i.startswith("_")]
li
```




    ['ChainMap',
     'Counter',
     'Iterable',
     'Mapping',
     'OrderedDict',
     'UserDict',
     'UserList',
     'UserString',
     'abc',
     'defaultdict',
     'deque',
     'namedtuple']




```python
from collections import OrderedDict

price_array = ['30.14', '29.58', '26.36', '32.56', '32.82']
date_array = ['20170118', '20170119', '20170120', '20170121', '20170122']

stock_dict = OrderedDict(
    (date, price) for date, price in zip(date_array, price_array))
stock_dict.keys()
```




    odict_keys(['20170118', '20170119', '20170120', '20170121', '20170122'])

