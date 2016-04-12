---
layout: post
title: 论推荐系统的Exploitation和Exploration
categories: 推荐系统
---
上一篇文章讲到，一个推荐系统，如果片面优化用户的喜好，很可能导致千篇一律的推荐结果。文中曾经用了一节来讨论为什么使用Exploitation & Exploration (E & E)结果可能依然不能“免俗”。其实，E & E是推荐系统里很有意思，但也非常有争议的一个算法。一方面，大家都基本明白这类算法的目的，每年有很多相关论文发表。另一方面，这是工业界对于部署这类算法非常谨慎，有的产品经理甚至视之为“洪水猛兽”。这篇文章就是要分析一下导致这个现象的一些因素。

## 走一步看一步的策略
***
这里再简单阐述一下什么是E & E。简单来说，就是我们在优化某些目标函数的时候，从一个时间维度来看，当信息不足或者决策不确定性（Uncertainty）很大的时候，我们需要平衡两类决策：

1. 选择现在可能最佳的方案
1. 选择现在不确定的一些方案，但未来可能会有高收益的方案

在做这两类决策的过程中，我们也逐渐对所有决策的不确定性不断更新不断加以新的认识。于是，**最终**，从时间的维度上来看，我们在不确定性的干扰下，依然能够去**优化**目标函数。

也就是说，E & E可以看做是一个*优化过程*，需要多次迭代才能找到比较好的方案。

## E & E的应用历史
***
早期把E & E应用于新闻推荐系统的文章（比如<sub>[1,2,4]</sub>）主要关注于Yahoo Today Module这一产品，这也基本上是最早E & E出现在互联网应用的尝试，目的是为了优化点击率（CTR）。而更早一些的奠基性的文章（如<sub>[3]</sub>）则是在广告的数据集上展示的实验结果。

> Deepak Agarwal，现任LinkedIn VP Of Engineering，主管Machine Learning和Relevance，是早年Yahoo推荐系统的缔造者之一，也是推荐系统的学术权威之一。其著作《Statistical Methods for Recommender Systems》是初学者必不可少的入门教材。

> Bee-Chung Chen，现任LinkedIn Senior Staff Software Engineer，其PhD导师Raghu Ramakrishnan现在是微软的CTO for Data和Technical Fellow（此人是早期知识图谱Knowledge Graph概念的推崇者）。Bee-Chung是Deepak在Yahoo年代的老部下，并且追随其到LinkedIn。他们是很多工作的共同作者。

> Lihong Li，现任微软研究院资深研究员。其在Yahoo的一系列有关Contextual Multi-Armed Bandit以及Thompson Sampling的文章奠定了其在这个领域的权威位置。他在WSDM 2015做的关于如何连接线下和线上系统的评估的讲座<sub>[5]</sub>，是非常有价值的学术资料。

Yahoo Today Module其实为E & E提供了一些很多学者和工业界人士忽视了的条件和成功因素。如果不考虑这些因素，鲁莽得使用这些文献相似的算法到其他场景，这可能产生很差的效果。那么是哪些因素呢？主要由两点：

1. **相对少量的优质资源**： Yahoo Today Module每天的Content Pool其实并不大。这里面都是网站编辑精选了的大概100篇文章。这些文章原本的质量就非常高。无论是这里面的任何一组，用户体验都没有明显变差。Content Pool每天都人为更换。
1. **非常大的用户量**：有亿万级的用户可能最终是从算法*随机*产生的文章排序中选择了阅读的文章。然而，因为用户数量巨大，所以算法就相对比较容易Converge到稳定的方案。也就是前面讲的，优化CTR的状态。

正因为有了（1）和（2），Deepak他们享受了在后来学者们所无法想象的“奢侈”，比如运行Epsilon-Greedy这种简单粗暴的E & E算法，甚至是**完全随机**显示新闻，收集到了很多*无偏*（Unbiased）的数据，为很多学术工作奠定了数据基础。时至今日，也有很多后续学者基于Yahoo Today Module的随机数据进行算法改进。

没有了这两条因素，Deepak的解决方案可能都没法在当时的Yahoo施行。原因很简单，如果资源良莠不齐，如果资源数量非常大，那么在仅有的几个展示位置，优质资源显示的可能性在短期内就会比较小（因为系统对于大多数的资源还有很高的不确定性，需要Explore）。而由于优质资源显示得少了，用户就会明显感受到体验的下降，直接可能就是更倾向于不点击甚至放弃使用产品。于是用户不Engage这样的行为又进一步减缓了系统学习资源的不确定性的速度。这时也许现在的亿万级用户数都没法满足学习所有资源的用户数量（毕竟所有用户只有一部分会落入Exploration）。

Deepak后来在LinkedIn推了相似的思路<sub>[6]</sub>，但是为了模拟Today Module的这些条件，则是对用户的内容流里的数据进行了大规模的过滤。这样只有少数的信息符合高质量的要求，并且能够在用户数允许的情况下Explore到合适的解决方案。

## E & E的产品部署难点
***
我们在上一节探讨了E & E的早期产品历史。这一节，我们来讲一下E & E的产品部署难点。这些难点是高于具体E & E算法选择（比如选某一个UCB或者某一个Thompson Sampling)的产品工程解决方案的抉择。


## 参考文献
***
1. Lihong Li, Wei Chu, John Langford, and Robert E. Schapire. **A Contextual-Bandit Approach to Personalized News Article Recommendation**. In Proceedings of WWW 2010.
1. Deepak Agarwal, Bee-Chung Chen, Pradheep Elango. **Explore/Exploit Schemes for Web Content Optimization**. In Proceedings of ICDM 2009.
1. John Langford, Alexander Strehl, and Jennifer Wortman. **Exploration Scavenging**. In Proceedings of ICML 2008.
1. Lihong Li, Wei Chu, John Langford, and Xuanhui Wang. **Unbiased Offline Evaluation of Contextual-Bandit-Based News Article Recommendation Algorithms**. In Proceedings of WSDM 2011.
1. Lihong Li. **Offline Evaluation and Optimization for Interactive Systems**。 In Proceedings of WSDM 2015.
1. Deepak Agarwal. **Recommending items to users: an explore/exploit perspective**. In Proceedings of the 1st Workshop on User Engagement Optimization at CIKM 2013.
