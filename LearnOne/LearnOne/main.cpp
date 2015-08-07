//
//  main.cpp
//  LearnOne
//
//  Created by guoyi on 15/8/7.
//  Copyright (c) 2015年 guoyi. All rights reserved.
//

#include <iostream>

using namespace std;

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    cout << "Hello, Guoyi\n\n";
    for (int i = 1; i < 10; i ++) {
        for (int j = 1; j <= i; j ++) {
            if (i*j < 10) {
                cout <<i<<"*"<<j<<" = "<<i*j<<"\t";
            } else {
                cout <<i<<"*"<<j<<" ="<<i*j<<"\t";
            }
        }
        cout << "\n";
    }
    return 0;
}
