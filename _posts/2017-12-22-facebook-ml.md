---
layout: post
title: Facebook的应用机器学习平台
categories: 读论文
---

我们在这里对Facebook应用机器学习（Applied Machine Learning）组发布的文章[Applied Machine Learning at Facebook: A Datacenter Infrastructure Perspective](https://research.fb.com/publications/applied-machine-learning-at-facebook-a-datacenter-infrastructure-perspective/)进行一个简单的分析解读。这篇文章可以让我们对Facebook里机器学习平台以及各个产品应用这个平台的情况有一个很不错的了解。

[全文PDF](https://research.fb.com/wp-content/uploads/2017/12/hpca-2018-facebook.pdf)

这篇文章的作者群来自Facebook的17位工程师和科学家。这些人可能仅仅是整个平台的骨干成员。可以看出整个Facebook的机器学习平台是一个有非常多人协作搭建的复杂环境。

这篇文章可以说是帮助外界解惑了很多迷思或者说是误解。同时，也给了大家一个学习大型互联网公司构建机器学习平台的机会。文章首先提出了一系列的重要观察：

*  Facebook有很多机器学习的应用场景。计算机视觉的应用仅仅是一个小部分。
*  Facebook有一个很丰富的机器学习库，包括Support Vector Machines、Logistic Regression、GBDT、MultiLayer Perceptron、CNN和RNN。
*  Facebook目前的机器学习场景同时利用GPU和CPU。在训练的时候，有很多是根据需要使用GPU和CPU，但是在Inference的时候，绝大多数还是使用CPU。
*  Facebook的机器学习架构很在乎分布式训练。

文章中列举了一些主要的Facebook机器学习应用场景包括我们熟知的News Feed、Ads和Search以外，还包括一些不那么为人知的应用，如Sigma（Facebook内部的Anomaly Detection的框架）、Lumos（看似是Image的Embedding和信息提取工具）、Facer（Facebook人脸识别框架）、Language Translation（顾名思义，就是一个语言翻译的平台）以及Speech Recognition（顾名思义，一个语音识别的平台）。由此可见，机器学习在Facebook里已经有了很广泛的应用。

那么，这些应用究竟在使用什么模型呢？Facer在使用SVM。Sigma在使用GBDT。Ads、News Feed和Sigma都在使用MLP。而Lumos、Facer在使用CNN。Text Understanding、Translation、Speech Recognition在使用RNN。

对于深度学习框架方面，目前Facebook支持两个框架：Caffe2和PyTorch。它们分别是生产环境和研究环境。作者们阐述了一下为什么要让这两个环境各不同。简而言之就是这两个环境的需求不用，一个要求稳定高效，一个要求能够灵活多变。当然，作者们也看到了多个深度学习框架带来的潜在问题。于是作者们提到了一个叫做Open Neural Network Exchange（ONNX）的交换格式。想来这个交换格式就是为了加快从一个框架到另外一个框架的转换速度。

从模型训练的时效性来看，有些应用的训练是每天，比如News Feed，而Search是每个小时，而其他应用则有些是每个星期或者每好几个月。而在Inference来看，第一，作者们提到了，不同的应用有可能需要不同的Inference的架构（Architecture）。同时，作者们还提到了并不是一开始就需要最精确的预测，有时候可以先展现给用户看没那么精确的结果，然后更加精确的结果可以算好以后再推给用户。

这篇文章还有很多细节的点值得关注。总之，如果你对机器学习在大型互联网公司的应用有兴趣，并且也想知道平台、软硬件的整体架构信息，这篇文章是一个不错的阅读材料。
