

# pandarallel

```python
import pandas as pd
import numpy as np
from pandarallel import pandarallel

pandarallel.initialize(nb_workers=4)

# ALLOWED
def func(x):
    return x**3
	
df=pd.DataFrame(np.random.rand(1000,1000))
df.parallel_apply(func, axis=1)
```

