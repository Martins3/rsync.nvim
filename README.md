# rsync.nvim

A mini version of coffebar/transfer.nvim.

I need a plugin to sync a local project into a virtual machine. Write code locally and test it remotely.

## Status

Work in progress 🔧 .

## Reference

- https://download.samba.org/pub/rsync/rsync.1
- https://stackoverflow.com/questions/4549945/is-it-possible-to-specify-a-different-ssh-port-when-using-rsync

## Similar projects

- [KenN7/vim-arsync](https://github.com/KenN7/vim-arsync)
- [OscarCreator/rsync.nvim](https://github.com/OscarCreator/rsync.nvim)
- [coffebar/transfer.nvim](https://github.com/coffebar/transfer.nvim)

## 问题
1. 出现错误的时候，没有报错
3. 切换配置文件之后，如何刷新?
    - 在 enable 的过程中，重新加载一次
    - 如何使用 status line 来通知 ?

将这段话整理下

- nvim 有待解决的问题，不是一时半会可以解决的:
  1. 编辑远程代码: 最佳状态是 vscode 的那种模式，收集一些替代，虽然都差的很远
     - https://github.com/jamestthompson3/nvim-remote-containers
     - https://github.com/OscarCreator/rsync.nvim
     - 但是 rsync 时间戳似乎维护的有问题，经常遇到这个问题: make: warning: Clock skew detected. Your build may be incomplete.

2. 将这两个 option 变为 option

	-- 忽视掉 .git --exclude=.git/
	-- 将 source 不存在的文件在 target 侧删除 --delete

3. 手动刷新配置文件

4. 制作更多的 template 吧
```txt
return {
	-- port = 1234,
	ip = "10.0.57.0",
	user = "root",
	location = "/root",
}
```
