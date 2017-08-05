---
layout: post
title: ACL 2017文章精读（五）
categories: 读论文
---

我们在这里对[ACL 2017](http://acl2017.org/)文章From Language to Programs: Bridging Reinforcement Learning and Maximum Marginal Likelihood进行一个简单的分析解读。

[全文PDF](https://arxiv.org/abs/1704.07926)

[代码地址](https://github.com/kelvinguu/lang2program)

这篇文章的作者群来自斯坦福大学。主要的作者们来自Percy Liang的实验室。最近几年Percy Liang的实验室可以说收获颇丰，特别是在自然语言处理（NLP）和深度学习（Deep Learning）的结合上都有不错的显著成果。

这篇文章里有好一些值得关注的内容。首先从总体上来说，这篇文章要解决的问题是怎么从一段文字翻译成为“程序”的问题。这可以说是一个很有价值的问题。如果这个问题能够可以容易解决，那么我们就可以教会计算机编写很多程序，而不一定需要知道程序语言的细微的很多东西。从细节上说，这个问题就是，给定一个输入的语句，一个模型需要把目前的状态转移到下一个目标状态上。这里面的难点是，对于同一个输入语句，从当前的状态到可能会到达多种目标状态。这些目标状态都有可能是对当前输入语句的一种描述。但是正确的描述其实是非常有限的，甚至是唯一的。那么，如何从所有的描述中，剥离开不正确的，找到唯一的或者少量的正确描述，就成为了这么一个问题的核心。

文章中采用了一个Neural Encoder-Decoder的模型架构。这种模型主要是对序列信息能够有比较好的效果。具体说来，那就是对于现在的输入语句，首先把输入语句变换成为一个语句向量，然后根据之前已经产生的程序状态，以及当前的语句向量，产生现在的程序状态。在这个整个的过程中，对于Encoder作者们采用了LSTM的架构，而对于Decoder作者们采用了普通的Feed-forward Network（原因文章中是为了简化）。另外一个比较有创新的地方就是作者们把过于已经产生程序状态重新给Embedding化（作者们说是叫Stack）。这有一点模仿普通数据结构的意思。

那么，这个模型架构应该说还是比较经典的。文章这时候就引出了另外一个本文的主要贡献，那就是对模型学习的流程进行了改进。为了引出模型学习的改进，作者们首先讨论了两种学习训练模式的形式，那就是强化学习（Reinforcement Learning）以及MML（Maximum Marginal Likelihood）的目标函数的异同。文章中提出两者非常类似，不过比较小的区别造成了MML可以更加容易避开错误程序这一结果。文章又比较了基于REINFORCE算法的强化学习以及基于Numerical Integration以及Beam Search的MML学习的优劣。总体说来，REINFORCE算法对于这个应用来说非常容易陷入初始状态就不太优并且也很难Explore出来的情况。MML稍微好一些，但依然有类似问题。文章这里提出了Randomized Beam Search来解决。也就是说在做Beam Search的时候加入一些Exploration的成分。另外一个情况则是在做Gradient Updates的时候，当前的状态会对Gradient有影响，也就是说，如果当前状态差强人意，Gradient也许就无法调整到应该的情况。这里，作者们提出了一种叫Beta-Meritocratic的Gradient更新法则，来解决当前状态过于影响Gradient的情况。

实验的部分还是比较有说服里的，详细的模型参数也是一应俱全。对于提出的模型来说，在三个数据集上都有不错的表现。当然，从准确度上来说，这种从文字翻译到程序状态的任务离真正的实际应用还有一段距离。

这篇文章适合对于最近所谓的Neural Programming有兴趣的读者泛读。对怎么改进强化学习或者MML有兴趣的读者精读。文章的“Related Work”部分也是非常详尽，有很多工作值得参考。
