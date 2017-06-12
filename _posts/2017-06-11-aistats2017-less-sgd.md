---
layout: post
title: AIStats 2017文章精读（二）
categories: 读论文
---

我们在这里对[AIStats 2017](http://www.aistats.org/)文章Less than a Single Pass: Stochastically Controlled Stochastic Gradient Method
进行一个简单的分析解读。

[全文PDF](http://proceedings.mlr.press/v54/lei17a/lei17a.pdf)

这篇文章的作者们来自加州大学伯克利分校。作者之一的Michael Jordan是机器学习的权威学者之一，曾经在概率图模型的时期有突出的贡献。

这篇文章主要还是讨论的大规模Convex优化的场景。在这个方面，已经有了相当丰富的学术成果。那么，这篇文章的主要贡献在什么地方呢？这篇文章主要想在算法的准确性和算法的通讯成本上下文章。

具体说来，这篇文章提出的算法是想在Stochastic Variance Reduced Gradient（SVRG）上进行更改。SVRG的主要特征就是利用全部数据的Gradient来对SGD的Variance进行控制。因此SVRG的计算成本（Computation Cost）是O((n+m)T)，这里n是数据的总数，m是Step-size，而T是论数。SVRG的通讯成本也是这么多。这里面的主要成本在于每一轮都需要对全局数据进行访问。

作者们提出了一种叫Stochastically Controlled Stochastic Gradient（SCSG）的新算法。总的来说，就是对SVRG进行了两个改进：
* 每一轮并不用全局的数据进行Gradient的计算，而是从一个全局的子集Batch中估计Gradient。子集的大小是B。
* 每一轮的SGD的更新数目也不是一个定值，而是一个和之前那个子集大小有关系，基于Geometric Distribution的随机数。

剩下的更新步骤和SVRG一模一样。

然而，这样的改变之后，新算法的计算成本成为了O((B+N)T)。也就是说，这是一个不依赖全局数据量大小的数值。而通过分析，作者们也比较了SCSG的通讯成本和一些原本就为了通讯成本而设计的算法，在很多情况下，SCSG的通讯成本更优。

作者们通过MNIST数据集的实验发现，SCSG达到相同的准确度，需要比SVRG更少的轮数，和每一轮更少的数据。可以说，这个算法可能会成为SVRG的简单替代。

对于大规模机器学习有兴趣的读者可以泛读。
