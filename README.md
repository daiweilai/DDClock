DDClock
=================================
A super simple and beautiful and high-efficiency clock widget. Drawing views using Quartz 2D Completely.

Demo Snapshot  
----------------------------------- 
![github](https://github.com/daiweilai/DDClock/blob/master/DDClock2.gif "github")

Setup
----------------------------------- 
#### CocoaPods
With CocoaPods you can simply add `DDClock` in your Podfile:
```
pod 'DDClock', '~> 1.0.0'
```
#### Source File
* Copy DDClock.h and DDClock.m to your project
* Then, import DDClock.h
* enjoy it

Using
----------------------------------- 
it's quite simple 
* You can use the themes to create DDClock

		DDClock *clock = [[DDClock alloc] initWithTheme:DDClockThemeDefault frame:CGRectMake(30, 60, 250, 250)];
		[self.view addSubview:clock];

* Or you can create DDClock via custom made

		//let your controller implement DDClockDelegate
		DDClock *clock = [[DDClock alloc] initWithDelegate:self frame:CGRectMake(100, 860, 120, 150)];
		[self.view addSubview:clock];
		
		//Then implement the delegate methods!!
		@optional
		-(UIColor*)rimColor;
		-(UIColor*)markColor;
		-(UIColor*)faceColor;
		-(UIColor*)fontColor;
		-(UIColor*)secondHandColor;
		-(UIColor*)hourAndMinuteHandColor;

Note
----------------------------------- 
* The size of DDClick can be modified in Construction method
* DDClick can only be created into a square , 
* So DDClock will force your size if you put the paras width which not equal the height 
* There is unwise way to update hourAndMinuteHand you shuld modify it

Created By
------------
* David Day(daiweilai)

License  
----------------------------------- 
Copyright David Day(daiweilai)

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
