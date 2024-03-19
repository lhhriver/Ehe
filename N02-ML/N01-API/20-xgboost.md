
# xgboost

## XGBClassifier


```python
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction import DictVectorizer
from xgboost import XGBClassifier

# titanic = pd.read_csv('http://biostat.mc.vanderbilt.edu/wiki/pub/Main/DataSets/titanic.txt')
# 数据准备
titanic = pd.read_csv('titanic.csv')
X = titanic[['pclass', 'age', 'sex']]
y = titanic['survived']
X['age'].fillna(X['age'].mean(), inplace=True)

X_train, X_test, y_train, y_test = train_test_split(X,
                                                    y,
                                                    test_size=0.25,
                                                    random_state=33)

vec = DictVectorizer(sparse=False)
X_train = vec.fit_transform(X_train.to_dict(orient='record'))
X_test = vec.transform(X_test.to_dict(orient='record'))

xgbc = XGBClassifier()
xgbc.fit(X_train, y_train)
print('The accuracy of eXtreme Gradient Boosting Classifier on testing set:\n',
      xgbc.score(X_test, y_test))
```

    The accuracy of eXtreme Gradient Boosting Classifier on testing set:
     0.7872340425531915
    