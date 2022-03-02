# preprocessing

---
> pad_sequences

```python
keras.preprocessing.sequence.pad_sequences(
	sequences, 
	maxlen=None,
	dtype='int32',
	padding='pre',
	truncating='pre', 
	value=0.)
```

- **sequences**：浮点数或整数构成的两层嵌套列表
- **maxlen**：None或整数，为序列的最大长度。大于此长度的序列将被截短，小于此长度的序列将在后部填0.
- **dtype**：返回的numpy array的数据类型
- **padding**：'pre'或'post'，确定当需要补0时，在序列的起始还是结尾补`
- **truncating**：'pre'或'post'，确定当需要截断序列时，从起始还是结尾截断
- **value**：浮点数，此值将在填充时代替默认的填充值0
