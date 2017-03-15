//
//  PythonTestViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/2/23.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "PythonTestViewController.h"

//#include <Python.h>
@interface PythonTestViewController ()
@property (nonatomic, strong) UILabel *resultLbl;
@end

@implementation PythonTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.resultLbl = [[UILabel alloc]initWithFrame:CGRectMake(80, 100, 300, 33)];
    self.resultLbl.backgroundColor = [UIColor whiteColor];
    self.resultLbl.textColor = [UIColor blackColor];
    [self.view addSubview:self.resultLbl];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self usePython];
}
- (void)usePython
{
    /*
    Py_Initialize();
    //导入某个库
    PyObject *myModule = PyImport_Import(PyString_FromString("urllib"));
    //拿到这个库的某个方法
    PyObject *theFunc = PyObject_GetAttrString(myModule, "urlopen");
    //检查这个方法是不是有效的
    if (theFunc && PyCallable_Check(theFunc)) {
        //设置参数
        PyObject *theArgs = PyTuple_New(1);
        PyTuple_SetItem(theArgs, 0, PyString_FromString("https://www.baidu.com"));
        //调用方法
        PyObject *f = PyObject_CallObject(theFunc, theArgs);
        //读
        PyObject *read = PyObject_GetAttrString(f, "read");
        //获得结果
        PyObject *result = PyObject_CallObject(read, NULL);
        
        if (result!=NULL) {
            printf("result of call: %s",PyString_AsString(result));
            self.resultLbl.text =[NSString stringWithCString:PyString_AsString(result) encoding:NSUTF8StringEncoding];
        }
    }
     */
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
