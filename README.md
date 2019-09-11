# HBGlobalProgressHud


## useage

1. podfile add subline

```
pod 'HBGlobalProgressHud', '0.0.2'
```


2. xxxx.m

#import<HBGlobalProgressHud/HBGlobalProgressHud.h>

use toast
```
[self presentMessage:@"hello world"];
```


use loading 
```
[self presentLoading:@"loading..."];

[self dismissAllTips];
```