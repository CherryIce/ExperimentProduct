# ExperimentProduct


得空尝试用swift复刻一下我们的原型图

//Note about image loading problems:

关于图片加载问题： 纯色图片不同地方颜色表现形式不一样 用tintColor

1.出现频率高的图标建议放在Assets资源里面 直接用imageNamed加载 需要UI做图时控制下大小 最好做好压缩

2.出现频率低的图标建议自己建立资源文件夹放置 然后用contentsOfFile加载

3.网络图片做好缓存操作 加载大图可以采用CATiledLayer尝试切片化加载

