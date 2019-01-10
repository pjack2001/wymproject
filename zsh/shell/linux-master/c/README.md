C 语言

## 内存泄露

内存泄露就是应用程序使用完一块内存空间之后没有将其释放。

一般应用程序的内在分为四块，堆区、栈区、全局数据区和代码区。其中堆区需要程序员自己管理，程序中使用的动态变量就存放在堆区，用完之后程序员要手动写代码进行释放，若申请了一块动态内存并且没有释放，这就叫内存泄露，会导致应用程序可用内存越来越少，进而拖垮操作系统。

举个例子如下：

路边一共有十个专门给过路人提供的休息室，张三从这里经过你给他第一个休息室使用并记录下来，休息完之后张三走了而你却没有将记录删除。李四从这里经过你给他第二个休息室使用并记录下来，休息完之后李四也走了而你却没有将记录删除。过一会王五也从这里经过，你分配休息室并记录，王五离开后你也没有删除记录，这样导致可用的休息室越来越少，进而导致没休息室可用。而实际情况却是休息室空着呢，但是你记录里显示有人在占用进而导致无法再分配给其他人使用。

以上张三、李四、王五是三个指针，休息室是内存地址，当指针使用完内存地址之后要将将其释放，不释放的结果就是最终导致无内存地址可用。C语言的`free`函数其实相当于切断指针和内存地址的指向关系，所以`free`完之后还需要将指针赋值为`NULL`。

## 内存溢出

内存溢出就是在使用一块内存时没有对其进行边界检查导致跃界。举个例子如下：

内存空间给姓名和借款各留了 6 个字符长度，正常情况下张三借了 300 元应该如下显示。

```
|姓  名|借  款|
|张三  |   300|
```

现在有个名叫 `李四五9999` 的人借了 500 元，由于没有对姓名进行边界检查，导致内存中的显示如下：

```
|姓  名|借  款|
|李四五|999900|
```

由此可见姓名中的 9999 溢出到了借款栏里并且把 500 中的 5 给覆盖掉了，结果成了李四五借款 999900 元。

## 变态 define

```
#define CALLBACK_DATA_(FOR, LEN, ER)                                 \
do {                                                                 \
  assert(HTTP_PARSER_ERRNO(parser) == HPE_OK);                       \
                                                                     \
  if (FOR##_mark) {                                                  \
    if (LIKELY(settings->on_##FOR)) {                                \
      parser->state = CURRENT_STATE();                               \
      if (UNLIKELY(0 !=                                              \
                   settings->on_##FOR(parser, FOR##_mark, (LEN)))) { \
        SET_ERRNO(HPE_CB_##FOR);                                     \
      }                                                              \
      UPDATE_STATE(parser->state);                                   \
                                                                     \
      /* We either errored above or got paused; get out */           \
      if (UNLIKELY(HTTP_PARSER_ERRNO(parser) != HPE_OK)) {           \
        return (ER);                                                 \
      }                                                              \
    }                                                                \
    FOR##_mark = NULL;                                               \
  }                                                                  \
} while (0)

/* Run the data callback FOR and consume the current byte */
#define CALLBACK_DATA(FOR)                                           \
    CALLBACK_DATA_(FOR, p - FOR##_mark, p - data + 1)

int function_name()
{
    case s_res_status:
    if (ch == CR) {
      UPDATE_STATE(s_res_line_almost_done);
      CALLBACK_DATA(status);
      break;
    }
}
```

以上代码出自

* <https://github.com/nodejs/http-parser/blob/fd65b0fbbdb405425a14d0e49f5366667550b1c2/http_parser.c#L104-L129>
* <https://github.com/nodejs/http-parser/blob/fd65b0fbbdb405425a14d0e49f5366667550b1c2/http_parser.c#L934-L945>

在宏定义里面`##`貌似会被忽略，比如此处的`status`在宏定义里面`FOR##_mark`会被解析成`status_mark`，第一次遇到这种用法。
