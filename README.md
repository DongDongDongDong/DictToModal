# DictToModal
仿JsonModal，实现Swift版的字典转模型
# 技术点

1、读取将Json数据读取转换成字典。

2、利用Runtime class_copyIvarList或者class_ProtocoList动态获取当前类的信息。（该方法需要free释放） 然后利用ivar_getName，ivar_getTypeEncoding获取属性名和类型等信息。

3、通过自定义协议，来获取模型中自定义对象的类型。（MJ是定义了一个协议，通过协议告诉“工具”自定义对象的类型，JSONModel是定义了很多协议，告诉“工具准确类型”）

4、运行时class_copyIvarList只能获取到当前类型的属性列表，不会获取到父类的属性列表。这时利用循环，递归遍历父类，获取所有属性。这时就要求模型类必须继承自NSObject，一是为了使用KVC，二是为了方便遍历。 
