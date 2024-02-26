# vector
## push_back 和 emplace_back
- push_back先构造一个对象，然后再拷贝(或移动)到容器末尾，而emplace_back直接可以在容器末尾构造对象。
- push_back只能接受一个参数，而emplace_back可以接受多个参数，用来调用容器内元素的构造函数。
- emplace_back直接在容器内部进行就地构造，如果构造函数抛出异常，可能会导致难以预料的问题。应使用异常安全的代码，尤其是在构造函数中。
- 避免在emplace_back或push_back调用中使用容器本身的引用或指针，因为容器在插入过程中可能会重新分配内存，导致引用或指针失效。
