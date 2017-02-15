本代码是为了在非越狱环境下劫持钉钉的GPS和WIFI信息并修改，可以自动设置为指定的任意位置，具体使用方法请见下方链接
1、GPS:http://www.chinapyg.com/thread-88593-1-1.html
2、WIFI:http://www.chinapyg.com/thread-89902-1-1.html

经过几次优化，已经可以满足所有app修改GPS和wifi的需求，但是有些app除了调用[[NSBundle mainBundle] bundleIdentifier]获取bundleIdentifier进行校验之外，还会通过解析info.plist文件获取bundleIdentifier，因此最好的防止被发现办法是：签名时，使用*.*的证书，不要修改app的bundleIdentifier。

1、DingTalkDylib中的代码可以劫持任意app，并进行GPS篡改；

2、DingTalkDylib+WIFI中的代码是在DingTalkDylib的基础上增加了WIFI信息劫持功能；

谨慎使用！

谨慎使用！

谨慎使用！
