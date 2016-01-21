# 如何用C语言编写一个PHP的C扩展

标签（空格分隔）： php

---


### 准备
PHP非常容易扩展,因为它提供了我们想用的所有API.下载PHP的源代码，如php-5.6.13。解压后进入php-5.6.13\ext目录。

查看命令的参数
```
lee@lee-work:~/Code/php-5.6.13/ext$ ./ext_skel --help
./ext_skel --extname=module [--proto=file] [--stubs=file] [--xml[=file]]
           [--skel=dir] [--full-xml] [--no-help]

  --extname=module   module is the name of your extension
  --proto=file       file contains prototypes of functions to create
  --stubs=file       generate only function stubs in file
  --xml              generate xml documentation to be added to phpdoc-svn
  --skel=dir         path to the skeleton directory
  --full-xml         generate xml documentation for a self-contained extension
                     (not yet implemented)
  --no-help          don't try to be nice and create comments in the code
                     and helper functions to test if the module compiled
```


### 第一步 创建扩展基础文件

输入./ext_skel --extname=项目名
```
lee@lee-work:~/Code/php-5.6.13/ext$ ./ext_skel --extname=testext
```
testext就是扩展的名称，执行后生成testext目录。

```
lee@lee-work:~/Code/php-5.6.13/ext$ ./ext_skel  --extname=testext
Creating directory testext
Creating basic files: config.m4 config.w32 .gitignore testext.c php_testext.h CREDITS EXPERIMENTAL tests/001.phpt testext.php [done].

To use your new extension, you will have to execute the following steps:

1.  $ cd ..
2.  $ vi ext/testext/config.m4
3.  $ ./buildconf
4.  $ ./configure --[with|enable]-testext
5.  $ make
6.  $ ./sapi/cli/php -f ext/testext/testext.php
7.  $ vi ext/testext/testext.c
8.  $ make

Repeat steps 3-6 until you are satisfied with ext/testext/config.m4 and
step 6 confirms that your module is compiled into PHP. Then, start writing
code and repeat the last two steps as often as necessary.

```

ext_skel是PHP官方提供用于生成php扩展基础代码的工具。
进入testext目录,可以看到config.m4、config.w32、CREDITS 、EXPERIMENTAL  、php_testext.h、testext.c、testext.php、tests
。config.m4 和config.w32是我们的配置文件,我是在linux下编译的 所以要修改config.m4文件。config.m4是AutoConf工具的配置文件，用来修改各种编译选项。

```
lee@lee-work:~/Code/php-5.6.13/ext$ cd testext
lee@lee-work:~/Code/php-5.6.13/ext/testext$ ls
config.m4  config.w32  CREDITS  EXPERIMENTAL  php_testext.h  testext.c  testext.php  tests
```

### 第二步 修改config.m4文件


修改config.m4文件内容,其中dnl在这个配置内代表注释
可以选择 with 或者enable ,enable方式需要重新编译PHP,所以我用 with,把它编译为so模块.

1.with

* with是作为动态链接库载入的

```
dnl PHP_ARG_WITH(testext, for testext support,
dnl Make sure that the comment is aligned:
dnl [  --with-testext             Include testext support])
```
修改内容为
```
PHP_ARG_WITH(testext, for testext support,
dnl Make sure that the comment is aligned:
[  --with-testext             Include testext support])
```

2.enable

* 表示编译到php内核中.这个配置文件创造了一个--enable-testext的配置选项,而PHP_ARG_ENABLE的第二个选项会在配置的时候显示出来

```
dnl PHP_ARG_ENABLE(testext, whether to enable testext support,
dnl Make sure that the comment is aligned:
dnl [  --enable-testext           Enable testext support])
```
修改内容为
```
PHP_ARG_ENABLE(testext, whether to enable testext support,
dnl Make sure that the comment is aligned:
[  --enable-testext           Enable testext support])
```

下面列出在config文件中可能有的配置选项：

* PHP_ARG_WITH 或者 PHP_ARG_ENABLE 指定了PHP扩展模块的工作方式，前者意味着不需要第三方库，后者正好相反
* PHP_REQUIRE_CXX 用于指定这个扩展用到了C++
* PHP_ADD_INCLUDE 指定PHP扩展模块用到的头文件目录
* PHP_CHECK_LIBRARY 指定PHP扩展模块PHP_ADD_LIBRARY_WITH_PATH定义以及库连接错误信息等
* PHP_ADD_LIBRARY(stdc++,”",EXTERN_NAME_LIBADD)用于将标准C++库链接进入扩展
* PHP_SUBST(EXTERN_NAME_SHARED_LIBADD) 用于说明这个扩展编译成动态链接库的形式
* PHP_NEW_EXTENSION 用于指定有哪些源文件应该被编译,文件和文件之间用空格隔开


### 第三步 编写testext.c文件

testext.c 添加下面的代码
```C
const zend_function_entry testext_functions[] = {
	PHP_FE(confirm_testext_compiled,	NULL)		/* For testing, remove later. */
	PHP_FE_END	/* Must be the last line in testext_functions[] */
};
```
修改为
```C
/*
函数主体
*/
PHP_FUNCTION(testext_helloworld)
{
	php_printf("Hello World!\n");
}

const zend_function_entry testext_functions[] = {
	PHP_FE(confirm_testext_compiled,	NULL)
	PHP_FE(testext_helloworld,	NULL)	/*注册*/
	PHP_FE_END
};
```


### 第四步 编译
在testext$目录下依次执行phpize、./configure 、make、make install。然后修改php.ini加入extension=testext.so

#### 1.phpize
```
lee@lee-work:~/Code/php-5.6.13/ext/testext$ phpize
Configuring for:
PHP Api Version:         20131106
Zend Module Api No:      20131226
Zend Extension Api No:   220131226
```
#### 2.configure
```
lee@lee-work:~/Code/php-5.6.13/ext/testext$ ./configure
....
creating libtool
appending configuration tag "CXX" to libtool
configure: creating ./config.status
config.status: creating config.h
config.status: config.h is unchanged
```
#### 3.make
```
lee@lee-work:~/Code/php-5.6.13/ext/testext$ make
...
If you ever happen to want to link against installed libraries
in a given directory, LIBDIR, you must either use libtool, and
specify the full pathname of the library, or use the `-LLIBDIR'
flag during linking and do at least one of the following:
   - add LIBDIR to the `LD_LIBRARY_PATH' environment variable
     during execution
   - add LIBDIR to the `LD_RUN_PATH' environment variable
     during linking
   - use the `-Wl,--rpath -Wl,LIBDIR' linker flag
   - have your system administrator add LIBDIR to `/etc/ld.so.conf'

See any operating system documentation about shared libraries for
more information, such as the ld(1) and ld.so(8) manual pages.
----------------------------------------------------------------------

Build complete.
Don't forget to run 'make test'.
```

#### 4.make install
```
lee@lee-work:~/Code/php-5.6.13/ext/testext$ sudo make install
[sudo] password for lee:
/bin/bash /home/lee/Code/php-5.6.13/ext/testext/libtool --mode=install cp ./testext.la /home/lee/Code/php-5.6.13/ext/testext/modules
cp ./.libs/testext.so /home/lee/Code/php-5.6.13/ext/testext/modules/testext.so
cp ./.libs/testext.lai /home/lee/Code/php-5.6.13/ext/testext/modules/testext.la
PATH="$PATH:/sbin" ldconfig -n /home/lee/Code/php-5.6.13/ext/testext/modules
----------------------------------------------------------------------
Libraries have been installed in:
   /home/lee/Code/php-5.6.13/ext/testext/modules

If you ever happen to want to link against installed libraries
in a given directory, LIBDIR, you must either use libtool, and
specify the full pathname of the library, or use the `-LLIBDIR'
flag during linking and do at least one of the following:
   - add LIBDIR to the `LD_LIBRARY_PATH' environment variable
     during execution
   - add LIBDIR to the `LD_RUN_PATH' environment variable
     during linking
   - use the `-Wl,--rpath -Wl,LIBDIR' linker flag
   - have your system administrator add LIBDIR to `/etc/ld.so.conf'

See any operating system documentation about shared libraries for
more information, such as the ld(1) and ld.so(8) manual pages.
----------------------------------------------------------------------
Installing shared extensions:     /usr/local/php/lib/php/extensions/no-debug-zts-20131226/

```

然后修改php.ini加入extension=testext.so

### 第五步 测试
```
lee@lee-work:~/Code/php-5.6.13/ext/testext$ php -r "testext_helloworld();"
Hello World!
lee@lee-work:~/Code/php-5.6.13/ext/testext$
```

