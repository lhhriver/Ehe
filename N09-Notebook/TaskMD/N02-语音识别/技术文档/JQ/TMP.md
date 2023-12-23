# 在线ASR

## 解码器内核

### 代码阅读

编译步骤：

  - 进入 source/make 目录

  - 运行./make\_all.sh

  - 在source/bin 目录下面生成可执行文件**onepass**，以及静态库**librecengine.a、libsrilm.a、libtools.a、libtshare.a** 和**libwfstdecoder.a**



`make_all.sh`

```shell
make -f Makefile_srilm clean
make -f Makefile_srilm -j 20

make -f Makefile_tooslib clean
make -f Makefile_tooslib -j 20

make -f Makefile_tshare clean
make -f Makefile_tshare -j 20

make -f Makefile_wfstdecoder clean
make -f Makefile_wfstdecoder -j 20

make -f Makefile_recengine clean
make -f Makefile_recengine -j 20

make -f  Makefile_onepass clean
make -f  Makefile_onepass

#cp ../bin/onepass ../testEnv/
```

