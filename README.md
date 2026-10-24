<div align="center">

<img src="Docs/Assets/logo.png" alt="Mac Display Volume" width="160" height="160">

# Mac Display Volume

**让 macOS 像控制普通扬声器一样，调节外接显示器的音量。**

[![Release](https://img.shields.io/github/v/release/wangmancang520/mac-display-volume?style=flat-square&label=Release)](https://github.com/wangmancang520/mac-display-volume/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/wangmancang520/mac-display-volume/total?style=flat-square&label=下载量)](https://github.com/wangmancang520/mac-display-volume/releases)
[![License](https://img.shields.io/github/license/wangmancang520/mac-display-volume?style=flat-square&label=许可证)](LICENSE)
![Platform](https://img.shields.io/badge/平台-macOS%2015%2B-blue?style=flat-square&logo=apple)
![Arch](https://img.shields.io/badge/架构-Apple%20Silicon-black?style=flat-square)
![Swift](https://img.shields.io/badge/Swift-6.2-F05138?style=flat-square&logo=swift&logoColor=white)
![C++](https://img.shields.io/badge/C++-20-00599C?style=flat-square&logo=cplusplus&logoColor=white)

[下载安装](#-下载安装) ·
[使用方法](#-使用方法) ·
[工作原理](#-工作原理) ·
[架构文档](Docs/Architecture.md) ·
[问题反馈](https://github.com/wangmancang520/mac-display-volume/issues) ·
[English](README.en.md)

</div>

> [!NOTE]
> 本仓库 fork 自 **[boyan01/mac-display-volume](https://github.com/boyan01/mac-display-volume)**，
> 核心功能与代码均来自原作者 [@boyan01](https://github.com/boyan01)。
> 本 fork 在原项目基础上提供简体中文文档和预编译的 Release 安装包。
> 如果这个项目对你有帮助，请先去[原项目](https://github.com/boyan01/mac-display-volume)点一个 ⭐。

---

## 📖 目录

- [项目简介](#-项目简介)
- [功能特性](#-功能特性)
- [适用场景](#-适用场景)
- [系统要求](#-系统要求)
- [下载安装](#-下载安装)
- [使用方法](#-使用方法)
- [常见问题](#-常见问题)
- [卸载](#-卸载)
- [工作原理](#-工作原理)
- [从源码构建](#-从源码构建)
- [项目结构](#-项目结构)
- [参与贡献](#-参与贡献)
- [致谢](#-致谢)
- [许可证](#-许可证)

## ✨ 项目简介

有些显示器通过 HDMI、DisplayPort 或 USB-C 接入 Mac 后，macOS 只能把它们当作**固定音量**的
音频输出设备：键盘音量键和菜单栏音量滑块不可用，或者调节的是显示器自身的硬件音量。
如果同一台显示器还连接着 Windows、游戏机或其他设备，音量设置就会互相影响。

Mac Display Volume 在 Mac 上创建一个**虚拟音频输出设备**，在软件层调节音量后，
再把声音转发给真实的显示器：

```text
macOS 应用
  └─▶ Mac Display Volume（虚拟输出设备）
        └─▶ 软件音量 / 静音
              └─▶ 真实的显示器扬声器
```

显示器的硬件音量可以一直保持固定，在 Mac 上调节音量不会影响其他设备。

## 🚀 功能特性

| 功能 | 说明 |
| --- | --- |
| 🔊 虚拟输出设备 | 创建名为 `Mac Display Volume` 的系统级音频输出设备 |
| 🎚️ 系统音量控制 | 支持键盘音量键、菜单栏滑块、系统设置中的音量和静音 |
| ⚡ 低延迟转发 | 将音频以低延迟转发到真实的显示器音频设备 |
| 🧭 菜单栏应用 | 在菜单栏中选择目标输出设备、查看驱动状态 |
| 🔁 一键切换 | 一键把系统默认输出切换到虚拟设备 |
| 🛡️ 硬件音量不变 | 显示器自身音量保持固定，不影响其他主机 |
| 🌏 多语言 | 界面支持简体中文与英文 |

## 🎯 适用场景

- 你使用带扬声器或音频输出的外接显示器；
- macOS 无法正常调节这台显示器的音量；
- 你希望音量调节只影响当前 Mac；
- 同一台显示器还会给 Windows、游戏机或其他设备使用。

## 💻 系统要求

- macOS 15 Sequoia 或更新版本
- Apple Silicon（M 系列芯片）Mac
- 一台支持音频输出、且支持 `48 kHz` 采样率的外接显示器

## 📦 下载安装

### 方式一：下载预编译版本（推荐）

1. 前往 [Releases 页面](https://github.com/wangmancang520/mac-display-volume/releases/latest)，
   下载最新的 `MacDisplayVolume-<版本号>-arm64.zip`。
2. 解压后，在终端中进入解压出来的文件夹，运行：

   ```sh
   ./install-release.sh
   ```

3. 按提示输入管理员密码。脚本会安装：
   - `/Applications/Mac Display Volume.app`
   - `/Library/Audio/Plug-Ins/HAL/MacDisplayVolumeAudio.driver`

> [!IMPORTANT]
> Release 包使用 ad-hoc 签名，没有经过 Apple 公证。安装脚本会自动清除下载隔离标记；
> 如果你手动拷贝应用，首次打开时需要在 Finder 中右键应用 → **打开**，
> 或到 **系统设置 → 隐私与安全性** 中允许运行。

### 方式二：从源码安装

需要 Xcode 26 或更新版本：

```sh
git clone https://github.com/wangmancang520/mac-display-volume.git
cd mac-display-volume
Scripts/install-local.sh
```

安装后如果系统中没有立刻出现新的音频设备，可以重启 CoreAudio；仍不出现时，
重启电脑通常可以清理 CoreAudio 缓存和旧的 driver 进程。

## 🕹️ 使用方法

1. 打开 `/Applications/Mac Display Volume.app`；
2. 在目标设备中选择真实的显示器音频设备，例如 `P275MV`；
3. 点击 **应用驱动配置**；
4. 点击 **使用虚拟输出**；
5. 保持显示器自身的硬件音量固定。

之后就可以用键盘音量键、菜单栏音量滑块或系统设置，调节 `Mac Display Volume` 的音量了。
驱动工作正常后，可以随时退出菜单栏应用，不影响音量控制。

## ❓ 常见问题

<details>
<summary><b>安装后在声音设置里看不到 Mac Display Volume？</b></summary>

在应用中点击 **重启 coreaudiod**，或在终端运行 `sudo killall coreaudiod`。
如果仍然看不到，请重启电脑。
</details>

<details>
<summary><b>声音延迟越来越大？</b></summary>

在应用中点击 **重置转发**。driver 本身会丢弃过旧的音频帧来限制延迟，
重置可以立即清空缓冲区。
</details>

<details>
<summary><b>选了目标设备但没有声音？</b></summary>

- 确认目标设备支持 `48 kHz` 采样率；
- 不要把 `Mac Display Volume` 自己设为目标设备；
- 检查显示器自身音量没有被调到 0 或静音。
</details>

<details>
<summary><b>CoreAudio 状态异常、设备列表错乱？</b></summary>

点击 **重启 coreaudiod**，或直接重启电脑。
</details>

## 🗑️ 卸载

```sh
Scripts/uninstall-local.sh
```

卸载脚本会删除应用和 HAL driver，并重启 CoreAudio。

## 🔧 工作原理

Mac Display Volume 由两部分组成：

| 组件 | 技术 | 职责 |
| --- | --- | --- |
| 菜单栏应用 | SwiftUI | 选择目标设备、下发驱动配置、切换系统默认输出、轮询驱动状态 |
| HAL driver | C++ / CoreAudio AudioServerPlugIn | 提供虚拟输出设备、处理软件音量与静音、转发音频 |

driver 由 `coreaudiod` 直接加载，实时音频路径完全运行在 C++ 中。它使用一个固定大小的
relay buffer 转发音频：当排队的音频过多时，会丢弃最旧的音频帧并重新对齐时间线，
避免累积数秒的延迟。

更多细节请参阅 [架构文档](Docs/Architecture.md)。

## 🛠️ 从源码构建

```sh
# 构建菜单栏应用，输出到 Build/Mac Display Volume.app
Scripts/build-app.sh

# 构建 HAL driver，输出到 Driver/Build/MacDisplayVolumeAudio.driver
Scripts/build-driver.sh

# 运行单元测试
swift test
```

如需在一次性 macOS 虚拟机中对 driver 做冒烟测试：

```sh
Scripts/vm-smoke-test.sh
```

该脚本会构建并安装 driver、重启 `coreaudiod`、检查 `system_profiler` 枚举和
bundle 加载、运行 `DriverProbe`，最后默认卸载 driver。

## 🗂️ 项目结构

```text
mac-display-volume/
├── Sources/
│   ├── DisplayVolumeApp/      # SwiftUI 菜单栏应用（含中英文本地化）
│   └── DisplayVolumeCore/     # CoreAudio 工具、驱动配置与状态解析
├── Driver/
│   └── Sources/               # CoreAudio HAL driver（C++）
├── Tools/DriverProbe/         # driver 诊断工具
├── Tests/                     # 单元测试
├── Scripts/                   # 构建、安装、卸载、测试脚本
└── Docs/                      # 架构文档与资源
```

## 🤝 参与贡献

- 🐛 Bug 与建议：[提交 Issue](https://github.com/wangmancang520/mac-display-volume/issues)
- 🔀 代码贡献：欢迎 Pull Request；与核心功能相关的改动，建议直接提交到
  [原项目](https://github.com/boyan01/mac-display-volume/pulls)，让更多人受益。

## 🙏 致谢

- 原项目作者 [@boyan01](https://github.com/boyan01) 与
  [boyan01/mac-display-volume](https://github.com/boyan01/mac-display-volume) 的所有贡献者。

## 📄 许可证

本项目基于 [Apache License 2.0](LICENSE) 开源，与原项目保持一致。

<div align="center">

<sub>Forked from <a href="https://github.com/boyan01/mac-display-volume">boyan01/mac-display-volume</a> · Made with ❤️ for macOS</sub>

</div>
