---
layout: post
title: WWW 2017文章精读（一）
categories: 读论文
---

我们在这里对WWW 2017文章Beyond Globally Optimal: Focused Learning for Improved Recommendations进行一个简单的分析解读。

[全文PDF](http://alexbeutel.com/papers/www2017_focused_learning.pdf)

这篇文章来自一群前CMU的学者，目前在Google和Pinterest。那么这篇文章试图解决什么问题呢？具体说来，就是作者们发现，传统的推荐系统，基于优化一个全局的目标函数，通常情况下往往只能给出一个非常有“偏差”（Skewed）的预测分布。也就是说，传统的推荐系统追求的是平均表现情况，在很多情况下的预测其实是十分不准确的。这个情况在评价指标是Root Mean Squared Error（RMSE）的时候，就显得尤为明显。

这篇文章的作者是这么定义了一个叫做Focused Learning的问题，那就是如果让模型在一个局部的数据上能够表现出色。那么，为什么需要模型在一个局部的数据上表现出色呢？作者们做了这么一件事情，那就是对每个用户，以及每一个物品的预测误差（Error）进行了分析统计，发现有不小比例的用户的预测误差比较大，也有不小比例的物品的预测误差比较大。作者们发现模型在一些数据上存在着系统性的误差较大的问题，而不是偶然发生的情况。

作者们又从理论上进行了对这个问题一番讨论。这里的讨论十分巧妙，大概的思路就是，假定现在在全局最优的情况下，模型的参数的梯度已经为0了，但模型的Loss依然不为0（这种情况很常见）。那么，就一定存在部分数据的参数梯度不为0，因为某一部分数据的Loss不为0。这也就证明了部分数据的模型参数在这些数据上的表现一定不是最优的。值得注意的是，这个证明非常普遍，和具体的模型是什么类型没有关系。

在有了这么一番讨论之后，那么作者们如何解决这个问题呢？这篇文章走了Hyper-parameter Optimization的道路。文章展示了这在普通的Matrix Factorization里面是如何做到。具体说来，就是对于某个Focused Set做Hyper-parameter的调优，使得当前的Hyper-parameter能够在Focused Set上能够有最好表现。而这组参数自然是针对不同的Focused Set有不同的选择。文章提到的另外一个思路，则是对Focused Set以及非Focused Set的Hyper-parameter进行区分对待，这样有助于最后的模型能够有一个比较Flexible的表达。

文章在实验的部分针对几种不同的Focused Set进行了比较实验。比如，针对Cold-Start的物品，针对Outlier的物品，以及更加复杂的libFM模型都进行了实验。我们在这里就不去复述了。总体来说，Focused Learning在不同的数据集上都得到了比较好的提升效果。同时，作者们还针对为什么Focused Learning能够Work进行了一番探讨，总体看来，Focused Learning既照顾了Global的信息，同时又通过附加的Hyper-parameter调优对某一个局部的数据进行优化，所以往往好于Global的模型以及也好于单独的Local模型。

本文非常适合对推荐系统有兴趣的学者和工程人员精读。
