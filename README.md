# 🌟 Emacs Light 配置说明书 λ
专门为 Common Lisp 和 Clojure 配置的 Emacs 轻量化编辑器

> ⚙️ 本配置适用于 Windows 和 Linux（Debian 系列），含语言支持、图形界面优化、开发工具链等完整说明。

## 🌠 展示图

![img1](https://github.com/user-attachments/assets/e8c2ff6c-bf4d-4eb7-b4d6-4b9ab0ef0415)
![img2](https://github.com/user-attachments/assets/92c529ba-9f7c-4346-ac83-c9f2cb7dd28a)

---

## 🖋️ 字体配置

### 💻 Windows 系统
将 `fonts/` 目录下所有字体复制到  
📁 `C:\Windows\Fonts\` 即可。

---

### 🐧 Linux 系统
执行以下命令：
```bash
mkdir -p ~/.fonts
cp *.ttf ~/.fonts/   # 或者拷贝单个字体
fc-cache -fv
```

---

## 📦 安装说明

### 🪟 Windows 环境

#### 📥 Emacs 安装
[GNU 官方下载](https://ftp.gnu.org/gnu/emacs/windows/)｜[镜像站点](https://mirror.ossplanet.net/gnu/emacs/windows/)

#### ⚙️ 开发环境依赖
| 工具名称 | 下载链接 |
|---------|----------|
| Git | [🔗](https://git-scm.com/downloads/win) |
| SBCL | [🔗](https://www.sbcl.org/platform-table.html) |
| Python | [🔗](https://www.python.org/downloads/) |
| NodeJS | [🔗](https://nodejs.org/zh-cn/download) |
| MSYS2 | [🔗](https://www.msys2.org/) 或 [Mingw](https://sourceforge.net/projects/mingw/) |

---

#### 🧬 Clojure 配置
- [Clojure 安装包](https://github.com/casselc/clj-msi)  
- [OpenJDK](https://adoptium.net/zh-CN)  
- [clj-kondo](https://github.com/clj-kondo/clj-kondo)

---

#### 🗂️ Dirvish 文件浏览器
```bash
winget install sharkdp.fd
pacman -S mingw-w64-ucrt-x86_64-libvips  # 透过 MSYS2
```

或者下载并加入系统变量：  
[下载 fd](https://github.com/sharkdp/fd/releases)

---

### 🐧 Linux 环境（适用：Debian、Mint、Ubuntu、Kali）

#### ⚙️ 基础工具安装
```bash
sudo apt install git sbcl
```

---

#### ☯️ Clojure 配置（Linux）
```bash
sudo apt install openjdk-17-jdk clojure leiningen

curl -sLO https://raw.githubusercontent.com/clj-kondo/clj-kondo/master/script/install-clj-kondo
chmod +x install-clj-kondo
./install-clj-kondo
```

---

#### 🐍 Python（使用 pyenv 安装推荐）
```bash
sudo apt install build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl git libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

curl https://pyenv.run | bash

# 添加到 ~/.bashrc 或 ~/.zshrc
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# 安装并使用 Python
pyenv install 3.11.9
pyenv global 3.11.9
```

---

#### 🌐 Node.js & NPM
```bash
sudo apt install nodejs npm
```

---

#### 🗂️ Dirvish 配置
```bash
sudo apt install fd-find libvips-tools ffmpegthumbnailer imagemagick poppler-utils
```
