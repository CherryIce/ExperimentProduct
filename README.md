# ExperimentProduct


得空尝试用swift复刻一下我们的原型图

//关于分支

main: -------- 

IGList: -------- 加入了IGList,处理了部分控制器

CALayer: -------- 使用AsyncDisplayKit node替代了部分UIView

//Note about image loading problems:

关于图片加载问题： 纯色图片不同地方颜色表现形式不一样 用tintColor

1.出现频率高的图标建议放在Assets资源里面 直接用imageNamed加载 需要UI做图时控制下大小 最好做好压缩

2.出现频率低的图标建议自己建立资源文件夹放置 然后用contentsOfFile加载

3.网络图片做好缓存操作 加载大图可以采用CATiledLayer尝试切片化加载

//尚未优化：-- 做个记录 --

level1:RPImageView后台下载处理

level2:RPTopicViewController - 换成 IGListKit &  AsyncDisplayKit 展示

level3:RPMineTopicController & RPMeidDetailViewController

level4:RPTopicDetailViewController - unfinish

level5:RPFindViewController

level6:RPDynamicController & RPFollowViewController

level7:others

//部分记录以及相关优化方案

最近在读电子书 看到的一个阅读类：https://github.com/dengzemiao/DZMeBookRead

还有另外一个：https://github.com/yuenov/reader-ios
        
项目里TYPagerController可以替换： 方案1：自己写两个collectionview 方案2：WMZPageController
        
类似微博、抖音、网易云等个人详情页滑动嵌套效果： https://github.com/QuintGao/GKPageScrollView  方案2：WMZPageController
        
现在项目里面用的骨架动画是OC版的TABAnimated，等有时间替换成Swift：https://github.com/Juanpe/SkeletonView

表单这种东西不知道咋说好 项目里面现在是自己写的 开源的Swift三方库有一个叫Eureka

图表:Charts

动画库：pop

