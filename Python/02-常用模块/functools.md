# functools


```python
import functools
```


```python
li = [i for i in dir(functools) if not i.startswith("_")]
li
```




    ['RLock',
     'WRAPPER_ASSIGNMENTS',
     'WRAPPER_UPDATES',
     'cmp_to_key',
     'get_cache_token',
     'lru_cache',
     'namedtuple',
     'partial',
     'partialmethod',
     'recursive_repr',
     'reduce',
     'singledispatch',
     'total_ordering',
     'update_wrapper',
     'wraps']

