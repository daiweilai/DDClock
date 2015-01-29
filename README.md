DDClock
=================================
A super simple and beautiful and high-efficiency clock widget. Drawing views using Quartz 2D Completely.

Demo Snapshot  
----------------------------------- 
![github](https://github.com/daiweilai/DDClock/blob/master/DDClock.gif "github")

Setup
----------------------------------- 
* Copy DDClock.h and DDClock.m to your project
* Then, import DDClock.h
* enjoy it

Using
----------------------------------- 
it's quite simple

		DDClock *clock = [[DDClock alloc] initWithTheme:DDClockThemeDefault position:CGPointMake(([UIScreen mainScreen].bounds.size.width - 200 )/2, 50)];
		[self.view addSubview:clock];


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
