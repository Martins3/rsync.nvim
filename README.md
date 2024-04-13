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
