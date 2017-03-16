# LXCoretextDemo
CoretextDemo 支持链接点击，和图片点击

#LXCoretextDataManager用于管理显示所需要的数据，以及显示内容的实际高度

#LXAttributeStringParser 生成属性字符串
> (NSAttributedString *)attributeStringWith:(NSArray<LXNormalContent *> *)contents config:(LXFrameParsesConfig *)config

#LXFrameParser 生成所需要的CTFrameRef并存入LXCoretextDataManager
> (LXCoretextDataManager *)parserAttributString:(NSAttributedString *)content withConfig:(LXFrameParsesConfig *)config

#运行结果

![image](https://github.com/liuxinxiaoyue/LXCoretextDemo/blob/master/ScreenShoot/1.png)
