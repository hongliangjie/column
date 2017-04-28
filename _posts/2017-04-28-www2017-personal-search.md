---
layout: post
title: WWW 2017文章精读（六）
categories: 读论文
---

我们在这里对WWW 2017文章Situational Context for Ranking in Personal Search进行一个简单的分析解读。

[全文PDF](https://ciir-publications.cs.umass.edu/pub/web/getpdf.php?id=1268)

这篇文章的作者群来自于University of Massachusetts Amherst（UMASS）以及Google。UMASS因为W. Bruce Croft（Information Retrieval领域的学术权威）的原因 ，一直以来是培养IR学者的重要学校。文章做这种的Michael Bendersky以及Xuanhua Wang都是Bruce Croft过去的学生。这篇文章想要讨论的是如何在个人搜索（Personal Search）这个领域根据用户的场景和情况（Situational Context）来训练有效的排序模型（Ranking Model）。

这篇文章的核心思想其实非常直观：

1.  场景信息对于个人搜索来说很重要，比如时间，地点，Device，因此试图采用这些信息到排序算法中，是非常显而易见的。
1.  作者们尝试采用Deep Neural Networks来学习Query以及Document之间的Matching。

具体说来，作者们提出了两个排序模型来解决这两个设计问题。第一个模型应该说是第二个模型的简化版。

第一个模型是把Query，Context，以及Document当做不同的模块元素，首先对于每一个模块分别学习一个Embedding向量。与之前的一些工作不同的是，这个Embedding不是事先学习好的（Pre-Trained）而是通过数据End-to-End学习出来的。有了各个模块的Embedding向量，作者们做了这么一个特殊的处理，那就是对于不同的Context（比如，时间、地点）学习到的Embedding，在最后进入Matching之前，不同Context的Embedding又组合成为一个统一的Context Embedding（这里的目的是学习到例如对时间、地点这组信息的统一规律），然后这个最终的Context Embedding和Query的，以及Document的Embedding，这三个模块进行Matching产生Relevance Score。

那么，第二个模型是建立在第一个模型的基础上的。思路就是把最近的一个所谓叫Wide and Deep Neural Networks（Wide and Deep）的工作给延展到了这里。Wide and Deep的具体思想很简单。那就是说，一些Google的研究人员发现，单靠简单的DNN并不能很好的学习到过去的一些非常具体的经验。原因当然是DNN的主要优势和目的就是学习数据的抽象表达，而因为中间的Hidden Layer的原因，对于具体的一些Feature也好无法“记忆”。而在有一些应用中，能够完整记忆一些具体的Feature是非常有必要的。于是Wide and Deep其实就是把一个Logistic Regression和DNN硬拼凑在一起，用Logistic Regression的部分达到记忆具体数据，而用DNN的部分来进行抽象学习。这第二个模型也就采用了这个思路。在第一个模型之上，第二个模型直接把不同Context信息又和已经学到的各种Embedding放在一起，成为了最后产生Relevance Score的一部分。这样的话，在一些场景下出现的结果，就被这个线性模型部分给记忆住了。

在实验的部分来说，文章当然是采用了Google的个人搜索实验数据，因此数据部分是没有公开的。从实验效果上来说，文章主要是比较了单纯的用CTR作为Feature，进行记忆的简单模型。总体说来，这篇文章提出的模型都能够对Baseline提出不小的提升，特别是第二个模型仍然能够对第一个模型有一个小部分但具有意义的提升。

这篇文章对于研究如何用深度学习来做文档查询或者搜索的研究者和实践者而言，有不小的借鉴意义，值得精读。
