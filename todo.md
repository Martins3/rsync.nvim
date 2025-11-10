## 问题
3. 切换配置文件之后，如何刷新?
    - 在 enable 的过程中，重新加载一次
    - 如何使用 status line 来通知 ?

- nvim 有待解决的问题，不是一时半会可以解决的:
  1. 编辑远程代码: 最佳状态是 vscode 的那种模式，收集一些替代，虽然都差的很远
     - https://github.com/jamestthompson3/nvim-remote-containers
     - https://github.com/OscarCreator/rsync.nvim
     - 但是 rsync 时间戳似乎维护的有问题，经常遇到这个问题: make: warning: Clock skew detected. Your build may be incomplete.

2. 将这两个 option 变为 option

	-- 忽视掉 .git --exclude=.git/
	-- 将 source 不存在的文件在 target 侧删除 --delete

3. 手动刷新配置文件

5. 如果打开了 rsync, 需要有 status 展示

6. 将事件修改为 focus change 可以吗?
    - 这样其实更加精确的，当离开了，就是要到其他的 server 端做事了。
