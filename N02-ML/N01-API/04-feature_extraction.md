```python
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

from jupyterthemes import jtplot
jtplot.style()

%matplotlib inline

import warnings

warnings.filterwarnings('ignore')

plt.style.use('ggplot')
plt.rcParams['font.sans-serif'] = 'SimHei'
plt.rcParams['axes.unicode_minus'] = False
```

# feature_extraction

## CountVectorizer

文本特征向量转化，只考虑词汇在文本中出现的频率


```python
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.model_selection import train_test_split
from sklearn.datasets import fetch_20newsgroups
from sklearn.naive_bayes import MultinomialNB
from sklearn.metrics import classification_report

news = fetch_20newsgroups(subset='all')
x_train, x_test, y_train, y_test = train_test_split(news.data[0:1000],
                                                    news.target[0:1000],
                                                    test_size=0.25,
                                                    random_state=33)

vec = CountVectorizer(analyzer='word', stop_words="english")
x_train = vec.fit_transform(x_train)
x_test = vec.transform(x_test)

mnb = MultinomialNB()
mnb.fit(x_train, y_train)
y_pred = mnb.predict(x_test)

print('The accuracy of classifying 20newsgroups using Naive Bayes (CountVectorizer by filtering stopwords):\n',
      mnb.score(x_test, y_test))
print(classification_report(y_test, y_pred, target_names=news.target_names))
```

    The accuracy of classifying 20newsgroups using Naive Bayes (CountVectorizer by filtering stopwords):
     0.612
                              precision    recall  f1-score   support
    
                 alt.atheism       0.38      0.50      0.43        10
               comp.graphics       0.70      0.44      0.54        16
     comp.os.ms-windows.misc       0.67      0.27      0.38        15
    comp.sys.ibm.pc.hardware       0.60      0.60      0.60        15
       comp.sys.mac.hardware       1.00      0.41      0.58        17
              comp.windows.x       0.28      1.00      0.44        12
                misc.forsale       0.60      0.27      0.37        11
                   rec.autos       0.50      0.17      0.25         6
             rec.motorcycles       0.60      0.82      0.69        11
          rec.sport.baseball       1.00      0.92      0.96        12
            rec.sport.hockey       0.79      0.94      0.86        16
                   sci.crypt       0.88      0.78      0.82         9
             sci.electronics       0.62      0.62      0.62        13
                     sci.med       0.89      0.62      0.73        13
                   sci.space       0.83      0.71      0.77        14
      soc.religion.christian       0.76      0.76      0.76        17
          talk.politics.guns       0.83      0.42      0.56        12
       talk.politics.mideast       1.00      0.77      0.87        13
          talk.politics.misc       0.17      0.80      0.29         5
          talk.religion.misc       0.83      0.38      0.53        13
    
                   micro avg       0.61      0.61      0.61       250
                   macro avg       0.70      0.61      0.60       250
                weighted avg       0.73      0.61      0.62       250


​    


```python
# vec.get_feature_names()  # 列表形式呈现文章生成的词典
# vec.vocabulary_   #  字典形式呈现，key：词，value:词频
# print(x_train.toarray())  # 是将结果转化为稀疏矩阵矩阵的表示方式；
# print(x_train.toarray().sum(axis=0))  #每个词在所有文档中的词频
```

## DictVectorizer




```python
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction import DictVectorizer
from sklearn.tree import DecisionTreeClassifier

data_li = [['3rd', None, 'female', 0], ['3rd', 17.0, 'female', 1],
         ['3rd', 17.0, 'male', 0], ['2nd', 17.0, 'female', 1],
         ['3rd', None, 'male', 1], ['3rd', 32.0, 'male', 0],
         ['3rd', 33.0, 'female', 1], ['2nd', 30.0, 'female', 1],
         ['3rd', None, 'male', 0], ['3rd', None, 'male', 1],
         ['3rd', 65.0, 'male', 0], ['1st', None, 'male', 1],
         ['3rd', 21.0, 'male', 1], ['1st', 53.0, 'female', 1],
         ['2nd', 1.0, 'male', 1], ['3rd', None, 'female', 0],
         ['3rd', None, 'female', 1], ['1st', 60.0, 'female', 1],
         ['3rd', None, 'male', 0], ['3rd', 43.0, 'male', 0],
         ['3rd', 35.0, 'male', 0], ['1st', 16.0, 'female', 1],
         ['1st', 41.0, 'male', 0], ['3rd', None, 'male', 0],
         ['2nd', 8.0, 'female', 1], ['2nd', 42.0, 'male', 0],
         ['3rd', None, 'male', 0], ['2nd', 18.0, 'male', 0],
         ['2nd', None, 'male', 1], ['1st', 18.0, 'female', 1]]

titanic = pd.DataFrame(data_li, columns=['pclass', 'age', 'sex', 'survived'])
titanic['age'].fillna(titanic['age'].mean(), inplace=True)

x_train, x_test, y_train, y_test = train_test_split(
    titanic[['pclass', 'age', 'sex']],
    titanic['survived'],
    test_size=0.25,
    random_state=33)

vec = DictVectorizer(sparse=False)
x_train = vec.fit_transform(x_train.to_dict(orient='record'))
print(vec.feature_names_)
x_test = vec.transform(x_test.to_dict(orient='record'))

dtc = DecisionTreeClassifier()
dtc.fit(x_train, y_train)
y_pred = dtc.predict(x_test)

print(dtc.score(x_test, y_test))
print(
    classification_report(y_pred,
                          y_test,
                          target_names=['died', 'survived'],
                          digits=4))
```

    0.7811550151975684
                  precision    recall  f1-score   support
    
            died     0.9059    0.7754    0.8356       236
        survived     0.5827    0.7957    0.6727        93
    
       micro avg     0.7812    0.7812    0.7812       329
       macro avg     0.7443    0.7856    0.7542       329
    weighted avg     0.8146    0.7812    0.7896       329


​    



## TfidfVectorizer


```python
from sklearn.metrics import classification_report
from sklearn.datasets import fetch_20newsgroups
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB

news = fetch_20newsgroups(subset='all')

x_train, x_test, y_train, y_test = train_test_split(
    news.data, news.target, test_size=0.25, random_state=33)

tfidf_filter_vec = TfidfVectorizer(analyzer='word', stop_words='english')
x_tfidf_filter_train = tfidf_filter_vec.fit_transform(x_train)
x_tfidf_filter_test = tfidf_filter_vec.transform(x_test)


mnb_tfidf_filter = MultinomialNB()
mnb_tfidf_filter.fit(x_tfidf_filter_train, y_train)
y_tfidf_filter_predict = mnb_tfidf_filter.predict(x_tfidf_filter_test)

print('The accuracy of classifying 20newsgroups with Naive Bayes (TfidfVectorizer by filtering stopwords):\n',
      mnb_tfidf_filter.score(x_tfidf_filter_test, y_test))

print(classification_report(
    y_test, y_tfidf_filter_predict, target_names=news.target_names))


```



    The accuracy of classifying 20newsgroups with Naive Bayes (TfidfVectorizer by filtering stopwords):
     0.8826400679117148
                              precision    recall  f1-score   support
    
                 alt.atheism       0.86      0.81      0.83       201
               comp.graphics       0.85      0.81      0.83       250
     comp.os.ms-windows.misc       0.84      0.87      0.86       248
    comp.sys.ibm.pc.hardware       0.78      0.88      0.83       240
       comp.sys.mac.hardware       0.92      0.90      0.91       242
              comp.windows.x       0.95      0.88      0.91       263
                misc.forsale       0.90      0.80      0.85       257
                   rec.autos       0.89      0.92      0.90       238
             rec.motorcycles       0.98      0.94      0.96       276
          rec.sport.baseball       0.97      0.93      0.95       251
            rec.sport.hockey       0.88      0.99      0.93       233
                   sci.crypt       0.85      0.98      0.91       238
             sci.electronics       0.93      0.86      0.89       249
                     sci.med       0.96      0.93      0.95       245
                   sci.space       0.90      0.97      0.93       221
      soc.religion.christian       0.70      0.96      0.81       232
          talk.politics.guns       0.84      0.98      0.90       251
       talk.politics.mideast       0.92      0.99      0.95       231
          talk.politics.misc       0.97      0.74      0.84       188
          talk.religion.misc       0.96      0.29      0.45       158
    
                   micro avg       0.88      0.88      0.88      4712
                   macro avg       0.89      0.87      0.87      4712
                weighted avg       0.89      0.88      0.88      4712

​    

```python
from sklearn.feature_extraction.text import TfidfVectorizer
 
tfidf = TfidfVectorizer()
 
corpus=["我 来到 北京 清华大学",#第一类文本切词后的结果，词之间以空格隔开
        "他 来到 了 网易 杭研 大厦",#第二类文本的切词结果
        "小明 硕士 毕业 与 中国 科学院",#第三类文本的切词结果
        "我 爱 北京 天安门"]#第四类文本的切词结果
 
result = tfidf.fit_transform(corpus).toarray()
print(result)

# 统计关键词
word = tfidf.get_feature_names()
print(word)

# 统计关键词出现次数，几句话对比几次
for k,v in tfidf.vocabulary_.items():
    print(k,v)
    
# 对比第i类文本的词语tf-idf权重
for i in range(len(result)):
    print('----------------------',i,'--------------------')
    for j in range(len(word)):
        print(word[j],result[i][j])
```


