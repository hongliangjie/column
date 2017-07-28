---
layout: post
title: ACL 2017文章精读（一）
categories: 读论文
---

我们在这里对[ACL 2017](http://acl2017.org/)文章Multimodal Word Distributions进行一个简单的分析解读。

[全文PDF](https://arxiv.org/abs/1704.08424)

[代码地址](https://github.com/benathi/word2gm)

文章作者[Ben Athiwaratkun](https://stat.cornell.edu/people/phds/ben-athiwaratkun)是康奈尔大学统计科学系的博士生。而Andrew Gordon Wilson则是新近加入康奈尔大学Operation Research以及Information Engineering的助理教授。其之前在卡内基梅隆大学担任研究员，师从Eric Xing教授和Alex Smola教授。再之前，其则在University of Cambridge的Zoubin Ghahramani手下攻读博士学位。

这篇文章主要是要研究Word Embedding，其核心思想其实很直观，那就是想用Gaussian Mixture Model去表示每一个Word的Embedding。最早的自然语言处理（NLP）是采用了One-Hot-Encoding的Bag of Word的形式来处理每个字。这样的形式自然是无法抓住文字之间的语义和更多有价值的信息的。那么，之前Word2Vec的想法则是学习一个每个Word的Embedding，也就是一个实数的向量，用于表示这个Word的语义。当然，如何构造这么一个向量又如何学习这个向量成为了诸多研究的核心课题。

在ICLR 2015会议上，来自UMass的Luke Vilnis 和Andrew McCallum在 “Word Representations via Gaussian Embedding”这篇文章中提出了用分布的思想来看待这个实数向量的思想。具体说来，就是认为这个向量是某个高斯分布的期望，然后通过学习高斯分布的参数（也就是期望和方差）来最终学习到Word的Embedding Distribution。这一步可以说是扩展了Word Embedding这一思想。然而，用一个分布来表达每一个字的最直接的缺陷则是无法表达很多字的多重意思，这也就是带来了这篇文章的想法。

这篇文章是希望通过Gaussian Mixture Model的形式来学习每个Word的Embedding。也就是说，每个字的Embedding不是一个高斯分布的期望了，而是多个高斯分布的综合。这样，就给了很多Word多重意义的自由度。在有了这么一个模型的基础上，文章采用了类似Skip-Gram的来学习模型的参数。具体说来，文章沿用了Luke和Andrew的那篇文章所定义的一个叫Max-margin Ranking Objective的目标函数，并且采用了Expected Likelihood Kernel来作为衡量两个分布之间相似度的工具。这里就不详细展开了，有兴趣的读者可以精读这部分细节。

文章通过UKWAC和Wackypedia数据集学习了所有的Word Embedding。所有试验中，文章采用了K=2的Gaussian Mixture Model（文章也有K=3的结果）。比较当然有之前Luke的工作以及其他各种Embedding的方法，比较的内容有Word Similarity以及对于Polysemous的字的比较。总之，文章提出的方法非常有效果。

这篇文章因为也有源代码（基于Tensorflow），推荐有兴趣的读者精读。
