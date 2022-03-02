```python
import torch
from torch import nn
from torchviz import make_dot

from torchvision.models import AlexNet

import os
os.environ["PATH"] += os.pathsep + 'C:/Program Files (x86)/graphviz-2.38/release/bin/'

model = AlexNet()

x = torch.randn(1, 3, 227, 227).requires_grad_(True)
y = model(x)
vis_graph = make_dot(y,
                     params=dict(list(model.named_parameters()) + [('x', x)]))
vis_graph.view('vis_graph')
# vis_graph.render('AlexNet_model', view=True)
```

