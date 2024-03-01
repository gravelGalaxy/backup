---
title: C++_Errors
date: 2023-11-17 09:43:06
tags: C/C++
---

# 遇到的一些C++错误和可能对应的错误位置

#### 表达式必须是可修改的左值
1. 若在函数内，检查该函数是否声明为const


#### 使用了已经被释放的对象
1. 检查是否代码中是否有以下类似错误：
```
queue<TCPMessage> messages{};
...
const TCPMessage &msg = messages.front();
...
messages.pop();
uint64_t size = msg.size();	//队列pop掉之后，就不能再使用这个引用，所以应该复制一份msg,而不是使用它的引用。
```


#### 非常量引用的初始值必须为左值
1. 定义了一个对变量的引用，但是初始化时赋值了一个右值。
```C++
string_view Buffer::get(){
	...
	return str;
}

// string_view &test = buffer.get();//这里不应该引用右值
string_view test = buffer.get();
```

#### 注意queue.front(), queue.back()等返回的是引用。
1. 将队列的首个元素的引用转化为右值。
```C++
string&& str = "";
if (not data_queue_.empty()) {
  str = std::move(data_queue_.front());
}
```

#### 能不能move一个const引用？
```
void NetworkInterface::send_datagram(const InternetDatagram& dgram, const Address& next_hop)
{
	datagrams_.push({move(next_hop), move(dgram)});
}


