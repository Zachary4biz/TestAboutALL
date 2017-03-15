//
//  compileTest.h
//  TestAboutALL
//
//  Created by Zac on 2017/3/15.
//  Copyright © 2017年 周桐. All rights reserved.
//

#ifndef compileTest_h
#define compileTest_h


#endif /* compileTest_h */




//1.1 小小说明一下objc-api.h里的OBJC_ISA_AVAILABILITY:

/*介绍一下__attribute__((deprecated))的作用,__attribute是给函数、变量、类做属性说明的关键字，deprecated是弃用原先的进行兼容
 
 若是__OBJC2__,原先的类，编译器发出警告*/
//#if !defined(OBJC_ISA_AVAILABILITY)
//#   if __OBJC2__
//#       define OBJC_ISA_AVAILABILITY    __attribute__((deprecated))
//#   else
//#       define OBJC_ISA_AVAILABILITY
//#   endif
//#endif
