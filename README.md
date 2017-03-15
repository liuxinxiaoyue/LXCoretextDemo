# LXCoretextDemo
Use CTCoretext draw content

#LXCoretextDataManager用于管理显示所需要的数据，以及显示内容的实际高度

#LXAttributeStringParser 生成属性字符串
> (NSAttributedString *)attributeStringWith:(NSArray<LXNormalContent *> *)contents config:(LXFrameParsesConfig *)config

#LXFrameParser 生成所需要的CTFrameRef并存入LXCoretextDataManager
> (LXCoretextDataManager *)parserAttributString:(NSAttributedString *)content withConfig:(LXFrameParsesConfig *)config
