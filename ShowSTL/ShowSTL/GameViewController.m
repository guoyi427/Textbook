//
//  GameViewController.m
//  ShowSTL
//
//  Created by guoyi on 15/9/1.
//  Copyright (c) 2015年 guoyi. All rights reserved.
//

#import "GameViewController.h"
#import <OpenGLES/ES2/glext.h>

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

// Uniform index.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    NUM_ATTRIBUTES
};

GLfloat gCubeVertexData[216] =
{
    // Data layout for each line below is:
    // positionX, positionY, positionZ,     normalX, normalY, normalZ,
    0.5f, -0.5f, -0.5f,        0.0f, 0.0f, 0.0f,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 0.0f,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, 0.0f,
    0.5f, 0.5f, 0.5f,          0.0f, 0.0f, 0.0f,
    
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, 0.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, 0.0f,
    0.5f, 0.5f, 0.5f,          0.0f, 0.0f, 0.0f,
    0.5f, 0.5f, 0.5f,          0.0f, 0.0f, 0.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 0.0f,
    
    -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 0.0f,
    
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, 0.0f,
    0.5f, -0.5f, -0.5f,        0.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 0.0f,
    0.5f, -0.5f, -0.5f,        0.0f, 0.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 0.0f,
    
    0.5f, 0.5f, 0.5f,          0.0f, 0.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 0.0f,
    
    0.5f, -0.5f, -0.5f,        0.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, 0.0f,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, 0.0f,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, 0.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, 0.0f
};

/// stl 结构体
typedef struct FaceStruct {
    GLKVector3 normal;
    GLKVector3 v1;
    GLKVector3 v2;
    GLKVector3 v3;
    u_int16_t attrib;
} FaceStruct;

/// 结构体大小
static const size_t FaceStructSize = 50;
/// stl文件前缀长度
static const NSUInteger SubfixSize = 80;
/// 缩小比例
static const GLfloat StlScale = 1.0f;

@interface GameViewController () {
    GLuint _program;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    float _rotation;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (void)setupGL;
- (void)tearDownGL;

- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //  准备数据
//    [self _prepareData];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
}

- (void)dealloc
{    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }

    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)_prepareData {

    /// 文件路径    RevolvedModel  visualization_-_aerial
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"RevolvedModel2" ofType:@"stl"];
    /// 文件管理器
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    /// 文件大小
    unsigned long long fileSize = [fileHandle seekToEndOfFile];
    printf("文件大小 = %llu\n\n",fileSize);

    //  设置起点
    [fileHandle seekToFileOffset:0];
    /// 前缀数据
    NSData *subfixData = [fileHandle readDataOfLength:SubfixSize];
    NSLog(@"前缀数据 = %@ \n",[[NSString alloc] initWithData:subfixData encoding:NSASCIIStringEncoding]);
    
    /// 遍历次数
    unsigned long stripeCount = (fileSize - SubfixSize - 4) / FaceStructSize;
    
    /// 新的 坐标数组
//    GLfloat vertex[36] = {};
    
    for (int stripe = 0; stripe < stripeCount; stripe++) {
        
//        NSLog(@"偏移量%llu",fileHandle.offsetInFile);
        
        /// 取出 数据源
        NSData *stripeData = [fileHandle readDataOfLength:FaceStructSize];
        
//        NSLog(@"三角形的数据 = %@",stripeData);
        
        /// 整合结构体
        FaceStruct face = {};
        [stripeData getBytes:&face length:FaceStructSize];
        
        /*
        printf("三角形结构体\n\
               x = %f y = %f z = %f \n\
               r = %f g = %f b = %f \n\
               s = %f t = %f p = %f\n\n",
               face.v1.x,face.v1.y,face.v1.z,
               face.v2.r,face.v2.g,face.v2.b,
               face.v3.s,face.v3.t,face.v3.p);
        */
        
        gCubeVertexData[stripe * 18]        = face.v1.x * StlScale;
        gCubeVertexData[stripe * 18 + 1]    = face.v1.y * StlScale;
        gCubeVertexData[stripe * 18 + 2]    = face.v1.z * StlScale;
        gCubeVertexData[stripe * 18 + 3]    = 0.0f;
        gCubeVertexData[stripe * 18 + 4]    = 0.0f;
        gCubeVertexData[stripe * 18 + 5]    = 0.0f;
        gCubeVertexData[stripe * 18 + 6]    = face.v2.x * StlScale;
        gCubeVertexData[stripe * 18 + 7]    = face.v2.y * StlScale;
        gCubeVertexData[stripe * 18 + 8]    = face.v2.z * StlScale;
        gCubeVertexData[stripe * 18 + 9]    = 0.0f;
        gCubeVertexData[stripe * 18 + 10]   = 0.0f;
        gCubeVertexData[stripe * 18 + 11]   = 0.0f;
        gCubeVertexData[stripe * 18 + 12]   = face.v3.x * StlScale;
        gCubeVertexData[stripe * 18 + 13]   = face.v3.y * StlScale;
        gCubeVertexData[stripe * 18 + 14]   = face.v3.z * StlScale;
        gCubeVertexData[stripe * 18 + 15]   = 0.0f;
        gCubeVertexData[stripe * 18 + 16]   = 0.0f;
        gCubeVertexData[stripe * 18 + 17]   = 0.0f;
    }
    

    
    [fileHandle closeFile];
    
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    [self loadShaders];
    
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.4f, 0.4f, 1.0f);
    
    glEnable(GL_DEPTH_TEST);
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(gCubeVertexData), gCubeVertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));

    glBindVertexArrayOES(0);
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    self.effect = nil;
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    
    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    //  旋转
    GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -4.0f);
    baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, _rotation, 0.0f, 1.0f, 0.0f);
    
    // Compute the model view matrix for the object rendered with GLKit
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -1.5f);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
    //  组合两种旋转  应该是在 上一次旋转的前提下 继续旋转   baseModelViewMatrix 记录了上一次的旋转角度
    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
    
    self.effect.transform.modelviewMatrix = modelViewMatrix;
    
    // Compute the model view matrix for the object rendered with ES2       OpenGLES2 使用 GLKMatrix3 做动画
    modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 1.5f);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
    
    _normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
    
    _modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    
    _rotation += self.timeSinceLastUpdate * 0.5f;
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glBindVertexArrayOES(_vertexArray);
    
    // Render the object with GLKit
    [self.effect prepareToDraw];
    
    glDrawArrays(GL_TRIANGLES, 0, 36);
    
    // Render the object again with ES2
    glUseProgram(_program);
    
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _normalMatrix.m);
    
    glDrawArrays(GL_TRIANGLES, 0, 36);
}

#pragma mark -  OpenGL ES 2 shader compilation

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
    glBindAttribLocation(_program, GLKVertexAttribNormal, "normal");
    
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

@end
