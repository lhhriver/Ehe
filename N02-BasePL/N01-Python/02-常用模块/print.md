

```python
def report_scores(self):
    """将结果用表格的形式打印出来，像这个样子：

                  precision    recall  f1-score   support
          B-LOC      0.775     0.757     0.766      1084
          I-LOC      0.601     0.631     0.616       325
         B-MISC      0.698     0.499     0.582       339
         I-MISC      0.644     0.567     0.603       557
          B-ORG      0.795     0.801     0.798      1400
          I-ORG      0.831     0.773     0.801      1104
          B-PER      0.812     0.876     0.843       735
          I-PER      0.873     0.931     0.901       634

      avg/total      0.779     0.764     0.770      6178
    """
    # 打印表头
    header_format = '{:>9s}  {:>9} {:>9} {:>9} {:>9}'
    header = ['precision', 'recall', 'f1-score', 'support']
    print(header_format.format('', *header))

    row_format = '{:>9s}  {:>9.4f} {:>9.4f} {:>9.4f} {:>9}'
    # 打印每个标签的 精确率、召回率、f1分数
    for tag in self.tagset:
        print(row_format.format(tag,
                                self.precision_scores[tag],
                                self.recall_scores[tag],
                                self.f1_scores[tag],
                                self.golden_tags_counter[tag]
                                ))

    # 计算并打印平均值
    avg_metrics = self._cal_weighted_average()
    print(row_format.format('avg/total',
                            avg_metrics['precision'],
                            avg_metrics['recall'],
                            avg_metrics['f1_score'],
                            len(self.golden_tags)
                            ))
```