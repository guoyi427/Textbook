//
//  main.cpp
//  LearnOne
//
//  Created by guoyi on 15/8/7.
//  Copyright (c) 2015年 guoyi. All rights reserved.
//

#include <iostream>

/// 命名空间
using namespace std;

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    
    for (int i = 1; i <= 9; i++) {
        for (int j = 1; j <= i; j ++) {
            if (i * j < 10) {
                cout << j << "*" << i << " =  " << i * j << "\t";
            } else {
                cout << j << "*" << i << " = " << i * j << "\t";
            }
        }
        cout << "\n";
    }
    
    return 0;
}
