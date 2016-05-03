//
//  XLayout.h
//  XLayout
//
//  Created by B&W on 16/4/26.
//  Copyright © 2016年 B&W. All rights reserved.
//

#ifndef XLayout_h
#define XLayout_h

#import "XLayoutBase.h"
#import "XLayoutViewService.h"

#import "UIView+XLayout.h"
#import "UIButton+XLayout.h"
#import "UITableView+XLayout.h"
#import "UITableViewCell+XLayout.h"
#import "UICollectionView+XLayout.h"
#import "UICollectionReusableView+XLayout.h"
#import "UIViewController+XLayout.h"

#endif /* XLayout_h */

/** 
    1.属性支持.
        XML里设置属性的时候,不仅仅可以设置布局类的属性,还可以设置你这个视图所有的只读属性,
        例如UILabel的text,UIView的backgroundColor等,包括你自己的自定义属性,前提是属性的类型不能是对象类型,
        这点很重要(对象类型可以通过引用实现,后边会说),NSString类型除外,结构体目前只支持了4种(CGPoint,CGSize,CGRect,UIEdgeInsets),
        枚举值直接设置为对应的数值即可.
        
    2.颜色属性支持
        通过@color:xx_color指定一个颜色,xx_color为16进制字符串,例如UIView的背景颜色:backgroundColor="@color:FF4040".
    3.图片属性支持
        通过@img:xx_img指定一张图片,xx_img为图片名称,例如UIImageView的图片:image="@img:avatar_img".
    4.字体属性支持
        通过@font:font_name:font_size指定一个字体,例如UILabel的字体:font="@font:default:17",
        default为系统默认字体,这里只是做演示,如果默认的话就不需要设置了,系统粗体使用font="@font:bold:17".
 
    5.属性引用支持.
        5.1 颜色引用
            Storyboard里边设置颜色的时候只能一个个设置,后来改也只能一个个改,手写代码的朋友可能会有一个app的全局配置文件,
            其他地方调用这个颜色配置就好了,以后改起来只需要改一个地方,很方便,引用就是类似的一个东西,它让你可以在XML里边引用一个配置,
            以后改只需要改配置文件就行了,下面说说实现方式,首先要去新建一个XLayoutViewService类的类别,这个类别名字随意,看你心情了,
            然后在里边定义一个UIColor属性,在getter方法里边返回一个UIColor对象就好了,然后在XML里边我们通过@quote关键字去引用这个属性,
            假如我在这个类别里边定义了一个叫做redColor的熟悉,然后我在设置UILabel的字体颜色,引用就可以这么写:textColor="@quote:redColor".
        5.2 图片引用
            跟颜色引用类似,只是定义的是一个UIImage的对象.
        5.3 字体引用
            跟颜色引用类似,只是定义的是一个UIFont的对象.
        5.4 注意事项
            所有的属性都可以用引用的方式来设置,比如上面说到的自定义对象,但是需要注意的是这里面定义的属性只能是对象,
            不能是基本类型,NSString类型除外,它跟属性支持刚好相反,所以可以用来互补.
 
    6.视图引用支持
        有些时候我们可能会把某些视图抽分出来做成公用的模块,Storyboard对这点支持很蛋疼,两个字,没法.
        视图引用则是用来解决这个问题的,首先把你需要公用的视图单独创建一个XML来写,然后在需要用到的XML内通过<import>标签来导入,
        例如:<import name="red_view"></import>,这样就完成了视图的引用,你可以在这个标签里添加其他的布局属性,
        也可以在red_view文件里边就定义了他在父视图中的位置,这里需要注意的是当两边都出现同样的布局属性时,可能会出现异常.
 
    7.Cell类的视图加载
        常用的就UITableViewCell跟UICollectionViewCell了,这两个对象都为他们写了一个宏定义,
        你只需要在.m文件里边引入这个宏,指定view的XML文件名称,然后在需要使用的地方注册这个Class就好了,
        需要注意的是因为这两个对象的内容都是加在contentView上的,所以你的XML根元素必须是一个UIView对象,
 
    8.布局扩展
        如果你觉得现有布局属性不够用,你可以继承XLayoutBase,去定义你自己的布局属性,实现自己的布局,
        然后在XML里边用这个布局属性就可以了,需要注意的是,如果你自定义了一个布局类,你需要在标签里边通过layout_class来指定你的布局类,
        例如:layout_class="my_layout_class".
    
    9.属性扩展
        有些属性不太好设置的,比如UIButton的image,因为它区分了状态,导致没有对应的属性可以用,
        这种你就可以去为对应的视图创建类别,定义一个属性,然后在这个属性的setter方法去完成对应的实现,
        可以参考UIButton+XLayout.h里边的定义,因为目前觉得常用的控件,除了UIButton外,其他的视图少用或者本身属性就已经支持了,就没有再做扩展.
    
    10.UIScrollView注意事项
        因为在auto情况下,UIScrollView的contentSize已经失效了,他的大小取决于所有子视图内容的大小,
        所以在布局时要特别注意,上下左右都要有对应的布局属性存在,让它能够知道自己的内容大小,否则布局可能会达不到自己想要的效果.
 

 */
