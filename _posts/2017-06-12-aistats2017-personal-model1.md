---
layout: post
title: AIStats 2017文章精读（三）
categories: 读论文
---

我们在这里对[AIStats 2017](http://www.aistats.org/)文章Decentralized Collaborative Learning of Personalized Models over Networks进行一个简单的分析解读。

[全文PDF](http://proceedings.mlr.press/v54/vanhaesebrouck17a/vanhaesebrouck17a.pdf)
[文章附加信息](http://proceedings.mlr.press/v54/vanhaesebrouck17a/vanhaesebrouck17a-supp.pdf)

这篇文章的作者们来自法国的INRIA和里尔大学（Universite de Lille）。文章讨论了一个非常实用也有广泛应用的问题，那就是所谓的Decentralized Collaborative Learning的问题，或者是说如何学习有效的个人模型（Personalized Models）的问题。

在移动网络的情况下，不同的用户可能在移动设备（比如手机上）已经对一些内容进行了交互。那么，传统的方式，就是把这些用户产生的数据给集中到一个中心服务器，然后由中心服务器进行一个全局的优化。可以看出，在这样的情况下，有相当多的代价都放到了网络通信上。同时，还有一个问题，那就是全局的最优可能并不是每个用户的最优情况，所以还需要考虑用户的个别情况。

比较快捷的方式是每个用户有一个自己的模型（Personalized Models），这个模型产生于用户自己的数据，并且能够很快地在这个局部的数据上进行优化。然而这样的问题则是可能没法利用全局更多的数据，从而能够为用户提供服务。特别是用户还并没有产生很多交互的时候，这时候可能更需要依赖于全局信息为用户提供服务。

这篇文章提出了这么几个解决方案。首先，作者们构建了一个用户之间的图（Graph）。这个图的目的是来衡量各个用户节点之间的距离。注意，这里的距离不是物理距离，而是可以通过其他信息来定义的一个图。每个节点之间有一个权重（Weight），也是可以通过其他信息定义的。在这个图的基础上，作者们借用了传统的Label Propagation，这里其实是Model Propagation的方式，让这个图上相近节点的模型参数相似。在这个传统的Label Propagation方式下，这个优化算法是有一个Closed-Form的结论。

当然，并不是所有的情况下，都能够直接去解这个Closed-Form的结论，于是这篇文章后面就提出了异步（Asynchronous）的算法来解这个问题。异步算法的核心其实还是一样的思路，不过就是需要从相近的节点去更新现在的模型。

第三步，作者们探讨了一个更加复杂的情况，那就是个人模型本身并不是事先更新好，而是一边更新，一边和周围节点同步。作者这里采用了ADMM的思路来对这样目标进行优化。这里就不复述了。

比较意外的是，文章本身并没有在大规模的数据上做实验而是人为得构造了一些实验数据（从非分布式的情况下）。所以实验的结果本身并没有过多的价值。

不过这篇文章提出的Model Propagation的算法应该说是直观可行，很适合对大规模机器学习有兴趣的学者和实验者精读。
