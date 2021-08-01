---
title: LaTeX基本操作
date: 2020-01-29 14:35:10
tags:
- LaTeX
categories: 
- 数学建模
- Latex
copyrignt: true
---

## 1.LaTeX环境的安装与配置
> 官网自行安装下载

## 2.LaTeX源文件的基本结构
 ```
	%导言区 注释
	\documentclass{article}%book, report, letter 
	\title{My First Document}
	\author{Lin Jun}	
	\date{\today}
	%正文区（文稿区）
	\begin{document}
	\maketitle 

	Hello World!

	%在源文件增加空行实现分行
	Let $f(x)$ be defined by the formula
	$f(x)=3x^2+x-1$.
	%使用$符号编辑行内数学公式
	$$f(x)=3x^2+x-1$$ which is a polynomial of degree 2.
	%使用$$符号编辑行间数学公式
	\end{document}
  ```
<!--more-->
## 3.LaTeX中的中文处理方法
### 1.设置构建的默认编译器为XeLaTeX
### 2.设置编辑器的编码格式为UTF-8

```
  %导言区 注释
  \documentclass{article}%book, report, letter 

  \usepackage{ctex} %引入中文宏包

  \newcommand\degree{^\circ} %在导言区进行命令的定义

  \title{\heiti 杂谈勾股定理}
  \author{\kaisu 不二}
  \date{\today}

  %正文区（文稿区）
  \begin{document}
     \maketitle 

  	勾股定理可以用现代语言表述如下:

  	直角三角形斜边的平方等于两腰的平方和。

  	可以用符号语言表述为: 设直角三角形 $ABC$, 其中 $\angle C=90\degree$, 则有:
  	\begin{equation}
  	AB^2 = BC^2 + AC^2.
  	\end{equation}
  	%引入equation环境 相当于$$符号
  	%注意angle C 之间需要有空格
  \end{document}	
```

## 4.LaTeX的字体设置
```
	在LaTeX中，一个字体有5中属性:
  1.字体编码
    正文字体编码: OT1、T1、EU1等
    数字字体编码: OML、OMS、OMX等
  2.字体族
    罗马字体: 笔画起始处有装饰
    \textrm{Roman Family}
    \rmfamily Roman Family 
    无衬线字体: 笔画起始处无装饰
    \textsf{Sans Serif Family}
    {\sffamily Sans Serif Family}
    打字机字体: 每个字符宽度 
    \texttt{Typewriter Family}
    {\ttfamily Typewriter Family}
  3.字体系列
  	粗细
  	\textmd{Medium Series}
  	{\mdseries Medium Series}
  	宽度
  	\textbf{Boldface Series}
  	{\bfseries Boldface Series}
  4.字体形状
    直立
    \textup{Upright Shape}
    {\upshape Upright Shape}
    斜体
    \textit{Italic Shape}
    {\itshape Italic Shape}
    伪斜体
    \textsl{Slanted Shape}
    {\slshape Slanted Shape}
    小型大写
    \textsc{Small Caps Shape}
    {\scshape Small Caps Shape}
  5.字体大小
  参看文档
  6.中文字体
  %需要使用ctex宏包
  {\songti 宋体}
  {\heiti 黑体}
  {\fangsong 仿宋} 
  {\kaisu 楷书} 	
  %\quad表示空格
  %\\表示换行
  %通常定义命令来实现字体操作
  \newcommand{\myfont}{\textit{\textbf{\textsf{Fancy Text}}}} 
```

## 5.LaTeX的篇章结构
```
   %导言区
  \documentclass{ctexbook}%ctexbook, ctexrep
  
  %\usepackage{ctex} 
  
  %在导言区可以使用ctexset进行格式设置
  
  %正文区
  
\begin{document}
  	\tableofcontents
  	
  	\chapter{实验与结果分析}
  	\section{引言} %小结 
  	\section{实验方法}  
  	\section{实验结果}
  	\subsection{数据} %子小结
  	\subsection{图表}
  	\subsubsection{实验条件} %子子小结
  	\subsubsection{实验过程}
  	\subsection{结果分析}
  	\section{结论}
  	\section{致谢}
  	
  	%题干构建 
  	%\par 实现另起段落
  
  	
\end{document}	  	
```

## 6.LaTeX中的特殊字符
```
   %导言区
  \documentclass{article}
  \usepackage{ctex} % 中文处理宏包
  \usepackage{xltxtra} %提供了针对XeTeX的改进并且加入XeTeX的LOGO
  % 正文区（文稿区）
  \begin{document}
  	\section{空白符号}
  	% 空行分段，多个空行等同1个
  	% 自动缩进，绝对不能使用空格代替
  	% 英文中多个空格处理为1个空格，中文中空格将被忽略
	% 汉字与其它字符的间距会自动由XeLaTeX处理
	% 禁止使用中文全角空格
  	\section{\LaTeX 控制符}
  	\# \$ \% \{ \} \~{} \_{} \^{} \textbackslash \&
  	\section{排版符号}
  	\S \P \dag \ddag \copyright \pounds
  	\section{\TeX 标志符号}
  	%基本符号
  	\TeX{} \LaTeX{} \LaTeXe{}
  	\XeLaTeX
  	\section{引号}
  	‘ ’ “ ”
  	\section{连字符}
  	- -- ---
  	\section{非英文字符}
  	\oe \OE
  	\section{重音符号(以o为例)}
  	\`o
  \end{document}	
```

## 7.LaTeX中的插图
```
	% 导言区
	\documentclass{ctexart}%ctexbook, ctexrep
	%\usepackage{ctex}
	% 导言区: \usepackage{graphicx}
	% 语  法: \includegraphics[<选项>]{<文件名>}
	% 格  式: EPS,PDF,PNG,JPEG,BMP
	\usepackage{graphicx}	
	\graphicspath{{figures/}}% 此处需要双括号
	% 正文区（文稿区）
	\begin{document}
	\LaTeX{}中的插图:
	\includegraphics[scale=0.25]{wallpaper}% 输入图片名,指定缩放因子
	%\includegraphics[height=5cm]{wallpaper}
	%\includegraphics[width=10cm]{wallpaper}
	%使用texdoc graphicx 查看文档
	\end{document}
```

## 8.LaTeX中的表格
```
	  % 导言区
  \documentclass{ctexart}%ctexbook, ctexrep
  %\usepackage{ctex}
  % 正文区（文稿区）
  \begin{document}
  	\begin{tabular}{|l|c|c|c|p{1.5cm}|}
  		% l 左对齐 c 居中对齐 r 右对齐 | 产生表格竖线 
  		%空格不起作用 p{<宽>}指定宽度 
  		%当内容超出时自动换行 & 表示不同列
  		%texdoc booktab
  		%texdoc longtab
  		%texdoc tabu
  		\hline %产生横线
  		姓名 & 语文 & 数学 & 外语 & 备注 \\
  		\hline %产生横线
  		张三 & 87 & 100 & 93 & 优秀 \\
  		\hline %产生横线
  		李四 & 75 & 64 & 52 & 补考另行通知 \\
  		\hline %产生横线
  		王二 & 80 & 82 & 78 & \\ 
  		\hline %产生横线
  		  	
  	\end{tabular}
\end{document}
```

## 9.LaTeX中的浮动体
```
	% 导言区
  \documentclass{ctexart}%ctexbook, ctexrep
  \usepackage{graphicx}	
  \graphicspath{figures/}
  %\usepackage{ctex}
  % 正文区（文稿区）
  \begin{document}
  	电脑壁纸见图\ref{fig-wallpaper}% 实现交叉引用
  	\begin{figure}[htbp]%图形位置 h 当前位置 t 顶部 b 底部 p 浮动页
  		\centering % 居中排列
  		\includegraphics[scale=0.25]{wallpaper}% 输入图片名,指定缩放因子
  		\caption{WallPaper}\label{fig-wallpaper} %设置图片名字 设置浮动体标签
  	\end{figure}
  	
  	当然，在\LaTeX{}中也如以下使用表\ref{tab-score}所示的表格
  	\begin{table}[h]
  		\centering
  		\caption{考试成绩单}\label{tab-score}
  		\begin{tabular}{|l|c|c|c|r|}
  			\hline %产生横线
  			姓名 & 语文 & 数学 & 外语 & 备注 \\
  			\hline %产生横线
  			张三 & 87 & 100 & 93 & 优秀 \\
  			\hline %产生横线
  			李四 & 75 & 64 & 52 & 补考另行通知 \\
  			\hline %产生横线
  			王二 & 80 & 82 & 78 & \\ 
  			\hline %产生横线	
  		\end{tabular}
  	\end{table}
  	
\end{document}
```

## 10.LaTeX数学公式初步
```
	% 导言区
\documentclass{article}%ctexbook, ctexrep

\usepackage{ctex}
\usepackage{amsmath}

% 正文区（文稿区）
\begin{document}
	\section{简介}
	\LaTeX{}将排版内容分为文本模式和数学模式。文本模式用于普通文本排版，数学模式用于数学公式排版。
	\section{行内公式}
	\subsection{美元符号}
	交换律是 $a+b=b+a$,如 $1+2=2+1=3$。
	\subsection{小括号}
	交换律是 \(a+b=b+a\),如 \(1+2=2+1=3\)。
	\subsection{math环境}
	交换律是 \begin{math}a+b=b+a\end{math},如\begin{math}
	1+2=2+1=3\end{math}
	\section{上下标}
	\subsection{上标}
	$3x^{20} - x + 2 = 0$
	
	$3x^{3x^{20} - x + 2} - x + 2 = 0$
	\subsection{下标}
	$a_0,a_1,a_2$
	
	$a_0,a_1,a_2,...,a_{3x^{20} - x + 2}$
	\section{希腊字母}
	$\alpha$
	$\beta$
	$\gamma$
	$\epsilon$
	$\pi$
	$\omega$
	
	$\Gamma$
	$\Delta$
	$\Theta$
	$\Pi$
	$\Omega$
	
	$\alpha^3 + \beta^2 + \gamma = 0$
	\section{数字函数}
	$\log$
	$\sin$
	$\cos$
	$\arcsin$
	$\arccos$
	$\ln$
	
	$\sin^2 x + \cos^2 x = 1$
	$y = \arcsin x$
	
	$y = \sin^{-1} x$ 
	
	$y = \log_2 x$
	
	$y = \ln x$
	
	$\sqrt{2}$
	$\sqrt{x^2 + y^2}$
	$\sqrt{2 + \sqrt{2}}$
	$\sqrt[4]{x}$ %通过[]指定开方的次数
	\section{分式}
	大约是原体积的$3/4$。
	大约是原体积的$\frac{3}{4}$。
	
	$\frac{x}{x^2 + x +1}$
	
	$\frac{\sqrt{x-1}}{\sqrt{x+1}}$
	
	$\frac{1}{1+ \frac{1}{x}}$
	
	$\sqrt{\frac{x}{x^2 + x + 1}}$

	\section{行间公式}
	\subsection{美元符号}
	交换律是 $$a+b=b+a$$
	如 $$1+2=2+1=3$$
	\subsection{中括号}
	 \[a+b=b+a\]
	 如
	 \[1+2=2+1=3\]
	\subsection{displaymath环境}
	\begin{displaymath}
		a+b=b+a,
	\end{displaymath},
	如
	\begin{displaymath}
		1+2=2+1=3.
	\end{displaymath}
	\subsection{自动编号公式equation环境}
	交换律见式\ref{eq:commutative}
	\begin{equation}
		a+b=b+a \label{eq:commutative}
	\end{equation}
	\subsection{不编号公式equation*环境}
	交换律见式\ref{eq:commutative2}
	\begin{equation*}
	a+b=b+a \label{eq:commutative2}
	\end{equation*}
\end{document}
```

## 11.LaTeX数学公式的矩阵
```
\documentclass{ctexart}%ctexbook, ctexrep
%\usepackage{ctex}
\usepackage{amsmath}
% 正文区（文稿区）
\begin{document}
	%矩阵环境，用&分隔列，用\\分隔行
	\[
	\begin{matrix}
	0 & 1\\
	1 & 0
	\end{matrix} \qquad
	% pmatrix环境 加小括号
	\begin{pmatrix}
	0 & -i\\
	i & 0
	\end{pmatrix} \qquad
	% bmatrix环境 加中括号
	\begin{bmatrix}
	0 & -i\\
	i & 0
	\end{bmatrix} \qquad
	% Bmatrix环境 加大括号
	\begin{Bmatrix}
	0 & -i\\
	i & 0
	\end{Bmatrix} \qquad
	% vmatrix环境 加单竖线
	\begin{vmatrix}
	0 & -i\\
	i & 0
	\end{vmatrix} \qquad
	% Vmatrix环境 加双竖线
	\begin{Vmatrix}
	0 & -i\\
	i & 0
	\end{Vmatrix} 
	\]

	% 可以使用上下标
	\[
	A = \begin{pmatrix}
	a_{11}^2 & a_{12}^2 & a_{13}^2 \\
	0 & a_{22} & a_{23} \\
	0 & 0 & a_{33}
	\end{pmatrix}
	\]

	%常用省略号：\dots,\vdots,\ddots
	\[
	A = \begin{pmatrix}
	a_{11} & \dots & a_{1n} \\
	& \ddots & \vdots \\
	0 & & a_{mn}
	\end{pmatrix}_{n \times n}% times命令排版乘号
	\]
\end{document}
```

## 12.LaTeX中的多行数学公式
```
% 导言区
\documentclass{ctexart}%ctexbook, ctexrep

%\usepackage{ctex}
\usepackage{amsmath}
\usepackage{amssymb}

% 正文区（文稿区）
\begin{document}
	% gather 和 gather* 环境 (可以使用\\换行)
	
	% 带编号
	\begin{gather}
		a + b = b + a \\
		ab ba
	\end{gather}
	
	% 不带编号
	\begin{gather*}
	3+5 = 5+3 = 8 \\
	3 \times 5 = 5 \times 3
	\end{gather*}
	
	% 在\\前使用\notag 阻止编号
	\begin{gather}
		3^2 + 4^2 = 5^2 \notag \\
		5^2 + 12^2 = 13^2 \notag \\
		a^2 + b^2 = c^2 
	\end{gather}
	
	% align 和 align* 环境 (用 & 进行对齐)
	% 带编号
	\begin{align}
	x &= t + \cos t + 1 \\
	y &= 2\sin t
	\end{align}
	% 不带编号
	\begin{align*}
		x &= t & x &= \cos t & x &= t \\
		y &= 2t & y &= \sin(t+1) & y &= \sin t 
	\end{align*}
	
	% split 环境(对齐采用 align 环境的方式，编号在中间)
	\begin{equation}
	\begin{split}
	\cos 2x &= \cos^2 x - \sin^2 x \\
	&= 2\cos^2 x - 1
	\end{split}
	\end{equation}
	
	% cases 环境
	% 每行公式中使用 &　分隔为两部分，
	%　通常表示值和后面的条件
	\begin{equation}
		D(x) = \begin{cases}
		1, & \text{如果 } x \in \mathbb{Q}; \\ %\in 用于输出属于符号 mathbb用于输出花体字符 \text{} 用于在数学模式中输入中文
		0, & \text{如果 } x \in \mathbb{R}\setminus\mathbb{Q}.
		\end{cases}
	\end{equation} 
\end{document}

```

## 13.LaTeX中的参考文献——BibTex
1. 在构件中设置默认文献工具为BibTex
2. 在谷歌学术中点击引用链接获取BibTex格式的数据
3. 新建.bib后缀的文件，复制获取参考文献数据

###  .tex文件如下
```
% 导言区
\documentclass{ctexart}%ctexbook, ctexrep

%\usepackage{ctex}

\bibliographystyle{plain}%指定排版样式 如plain unsrt alpha abbrv

% 正文区（文稿区）
\begin{document}
	%一次管理，一次使用
	%参考文献格式：
	%\begin{thebibliography}{编号样本}
	%	\bibitem[label]{citekey}文献条目1
	%   \bibitem[label]{citekey}文献条目2
	%	……
	%\end{thebibliography}
	%其中文献条目包括：作者，题目，出版社，年代，版本，页码等。
	%引用时候要可以采用：\cite{引用标志1，引用标志2，……}
	引用一本Guide\cite{latexGuide}等等
	\begin{thebibliography}{99}
		\bibitem{latexGuide} Kopka Helmut, W. Daly Patrick,
		\emph{Guide to \LaTeX}, $4^{th}$ Edition.
		Available at \texttt{http://www.amazon.com}.
	\end{thebibliography}
	这是一个参考文献的引用：\cite{scott1988social}
	\bibliography{test}
\end{document}
```

### .bib文件如下
```
  @article{scott1988social,
  title={Social network analysis},
  author={Scott, John},
  journal={Sociology},
  volume={22},
  number={1},
  pages={109--127},
  year={1988},
  publisher={British Sociological Association Publications Limited}
}
```

## 15.LaTeX中定义新命令和环境
```
	% 导言区
\documentclass{ctexart}%ctexbook, ctexrep

% \newcommand{cmd}{def}定义命令
% 命令只能由字母组成，不能以\end 开头
% \newcommand{命令}[参数个数][首字母默认值]{具体定义}

% \newcommand可以是简单字符串替代，例如：
% 使用\PRC 相当于 People's Republic of \emph{China} 这一串内容
\newcommand\PRC{People's Republic of \emph{China}}%\emph{text}表示强调

% \newcommand也可以使用参数
% 参数个数可以从1到9，使用时用 #1，#2，……，#9 表示
\newcommand\loves[2]{#1 喜欢 #2}
\newcommand\hatedby[2]{#2 不受 #1 喜欢}

% \newcommand的参数也可以有默认值
% 指定参数个数的同时指定了首个参数的默认值，那么这个命令的
% 第一个参数就成为可选的参数(要使用中括号指定)
\newcommand\love[3][喜欢]{#2#1#3}

% \renewcommand-重定义命令
% 与\newcommand 命令作用和用法相同，但只能用于已有命令
% \renewcommand{cmd}[args][default]{def}
\renewcommand\abstractname{内容简介}

% 定义和重定义环境
% \newenvironment{name}[args][default]{begdef}{enddef}
% \renewenvironment{name}[args][default]{begdef}{enddef}

% 为 book 类中定义摘要(abstract) 环境
\newenvironment{myabstract}[1][摘要]%
{\small
	\begin{center}\bfseries #1\end{center}%
	\begin{quotation}}%
{	
	\end{quotation}
}

% 正文区（文稿区）
\begin{document}
	\PRC
	
	\loves{猫儿}{鱼}
	
	\hatedby{猫儿}{萝卜}
	
	\love{猫儿}{鱼}
	
	\love[最爱]{猫儿}{鱼}
	
	\begin{abstract}
		这是一段摘要...
	\end{abstract}
	
	\begin{myabstract}[我的摘要]
		这是一段自定义格式的摘要...
	\end{myabstract}
	
\end{document}
```

# 完整的演示代码见Github仓库https://github.com/Gemini-Lin/MCM-ICM