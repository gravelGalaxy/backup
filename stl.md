# push_back和emplace_back
push_back和emplace_back都能接受一个左值或者右值。push_back接受右值实际上是调用的emplac_back函数。
这两个的主要区别是，push_back的参数只能是一个构造好的对象，而empalce_back的参数可以是对象的构造函数参数，直接就地构造。

```
// emplace_back({1, 1}); => error: 不支持，因为{1, 1}是initializer_list
push_back({1, 1}); =>支持
```
