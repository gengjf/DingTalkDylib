本代码是为了在非越狱环境下劫持钉钉的GPS和WIFI信息并修改，可以自动设置为指定的任意位置，具体使用方法请见下方链接
1、GPS:http://www.chinapyg.com/thread-88593-1-1.html
2、WIFI:http://www.chinapyg.com/thread-89902-1-1.html
3、水印：http://www.chinapyg.com/forum.php?mod=viewthread&tid=90452

经过几次优化，已经可以满足所有app修改GPS和wifi的需求，但是有些app除了调用[[NSBundle mainBundle] bundleIdentifier]获取bundleIdentifier进行校验之外，还会通过解析info.plist文件获取bundleIdentifier，因此最好的防止被发现办法是：签名时，使用*或com.*的证书，不要修改app的bundleIdentifier。

1、DingTalkDylib+WIFI中的代码可以劫持任意app，并进行GPS和WIFI篡改；

2、DingTalkDylib+WIFI+Camera中的代码新增了相机图片劫持功能，签到时可以将水印打在指定的图片上；

DingTalk从3.5.1版本开始新增了GPS劫持检测，上面的代码已经做了反检测。

谨慎使用！

谨慎使用！

谨慎使用！
