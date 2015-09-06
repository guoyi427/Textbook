//
//  Shader.fsh
//  OpenGL-ES
//
//  Created by guoyi on 15/8/24.
//  Copyright (c) 2015年 guoyi. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
