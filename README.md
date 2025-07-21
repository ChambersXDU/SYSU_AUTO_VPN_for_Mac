# SYSU_AUTO_VPN_for_Mac

一个简单的 [Hammerspoon](https://www.hammerspoon.org/) 脚本，用于在 macOS 上自动完成 EasyConnect 客户端的登录流程，包括自动填充密码和 2FA/MFA (TOTP) 验证码。

## 🚀 安装与配置

#### 步骤 1: 安装依赖

```bash
# 安装 oath-toolkit (用于生成 2FA 验证码)
brew install oath-toolkit

# 安装 Hammerspoon （也可以在官网安装）
brew install --cask hammerspoon
```
安装完成后，请确保在 **系统设置 -> 隐私与安全性 -> 辅助功能** 中为 Hammerspoon 启用权限。

#### 步骤 2: 配置脚本

从 macOS 菜单栏点击 Hammerspoon 图标 -> Open Config，打开配置文件，把仓库中的init.lua的代码复制进去，并根据你的个人信息进行修改。


#### 步骤 3: 重载配置

保存文件后，从 macOS 菜单栏点击 Hammerspoon 图标 -> Reload Config，使配置生效。

## 💡 如何使用
按下快捷键：`Control + Option + Command + E`，脚本将自动执行以下操作：
  *   等待几秒钟让应用准备就绪。
  *   将焦点从用户名移动到密码框。
  *   输入密码并提交。
  *   等待 2FA/MFA 页面加载。
  *   生成并输入 6 位验证码，完成登录。
