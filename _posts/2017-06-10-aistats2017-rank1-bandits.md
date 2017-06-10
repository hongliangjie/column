---
layout: post
title: AIStats 2017文章精读（一）
categories: 读论文
---

我们在这里对[AIStats 2017](http://www.aistats.org/)文章Stochastic Rank-1 Bandits进行一个简单的分析解读。

[全文PDF](http://proceedings.mlr.press/v54/katariya17a/katariya17a.pdf)

[文章附加信息](http://proceedings.mlr.press/v54/katariya17a/katariya17a-supp.pdf)

这篇文章的作者群来自于几个大学和Adobe Research。作者群中的Branislav Kveton和Zheng Wen在过去几年中发表过多篇关于Bandits的文章，值得关注。

这篇文章解决的问题是一个在应用中经常遇到的问题，那就是每一步Agent是从一对Row和Column的Arms中选择，并且得到他们的外积（Outer Product）作为Reward。这个设置从搜索中的Position-based Model以及从广告的推广中都有应用。

具体的设置是这样的，先假设我们有K行，L列。在每一个时间T步骤中有一个行（Row）向量u，从一个分布中抽取（Draw）出来，同时有一个列（Column）向量v，从另外一个分布中抽取出来。这两个抽取的动作是完全独立的。在这样的情况下， Agent在时间T，需要选择一个综合的Arm，也就是一个两维的坐标，i和j，从而在u和v的外积（Outer Product）这个矩阵中得到坐标为i和j的回报（Reward）。

文章指出，这个设置可以被当做是有K乘以L那么多个Arm的简单的Multi-armed Bandit。那么当然可以用UCB1或者是LinUCB去解。然而文章中分析了这样做的不现实性，最主要的难点在K和L都比较大的情况下，把这个场景的算法当做原始的Multi-armed Bandit就会有过大的Regret。

这篇文章提出了一个叫做Rank1Elim的算法来有效的解决这个问题。我们这里不提这个算法的细节。总体说来，这个算法的核心思想，就是减少行和列的数量，使得需要Explore的数量大大减少。这也就是算法中所谓Elimination的来历。那么，怎么来减少行列的数量呢？虽然作者们没有直接指出，不过这里采用和核心思想就是Clustering。也就是说，有相似回报（Reward）的行与列都归并在一起，并且只留下一个。这样，就能大大减少整个搜索空间。

文章主要的篇幅用在了证明上，这里就不去复述了。文章在MovenLens的数据集上做了一组实验，并且显示了比UCB1的Regret有非常大的提高。

这篇文章适合对推荐系统的Exploitation和Exploration有研究的学者泛读。
