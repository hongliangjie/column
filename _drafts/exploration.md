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
我们在上一节探讨了E & E的早期产品历史。这一节，我们来讲一下E & E的产品部署难点。这些难点是普遍高于具体E & E算法选择（比如选某一个UCB或者某一个Thompson Sampling)的产品工程解决方案的抉择。

### 难点一：如何上线测试
***
这看上去不应该是难点，但实际上需要额外小心。传统E & E文献，只是把问题抽象为每一次访问需要做一个决策的选择。然而，文献却没有说，这些访问是否来自同一个用户。那么，理论上，E & E应该对所有的访问不加区别，不管是否是同一个用户。虽然理论上这样做没有问题，但实际上，用户体验会有很大的差别。特别是一些推荐网站，用户希望自己前后两次对网站的访问保持**一致性**。如何不加区分得E & E，很可能对于同一个用户来说，产生某一次访问内容的策略和另外一次策略非常不一样，导致两次看见的内容迥异。同时，这会对用户熟悉产品界面，寻找喜爱的内容产生非常大的障碍。

那么，我们对某一部分用户Exploit，对另外一部分用户Explore，这样会好一些吗？这其实就是用“牺牲”少部分用户的代价来换取绝大多数人的体验一致性。这样实现也是最直观的，因为很多在线系统的A/B测试系统是根据用户来进行逻辑分割的。也就是说，某一部分用户一定会进入某一个Bucket，而另一批用户会进入另外一个Bucket。这样，E & E可以很容易和Bucket System一致起来，很容易部署。当然，这样做也是有潜在风险的。那就是，那部分老是Explore的用户，在当了别人的小白鼠以后，很可能有些人就永远放弃了产品。

其实，选择一个更好的部署模式，目前并没有公开的文献以及比较能够通用的方案。这方面其实是一个值得思考的研究课题。

### 难点二：如何评测
***
对现代推荐系统（以及很多类似系统）来说，在线系统的评测，也就是说如何衡量一个算法或者一个功能的好坏，往往是依赖于复杂的A/B测试系统。这里的逻辑很简单，那就是，把一群人分为**相等**的两份（可以扩展到多份），一部分看A系统结果，另一部分人看B系统结果，然后根据一些用户指标（比如点击率）来决定究竟是A系统好还是B系统。也就是说，A/B测试系统是按照人群来分的。对于同一个人来说，在某一段时间内，一般是只能看到A**或者**B系统，但**不**是**都**能看见。

那么，这样的A/B评测系统就和前面的上线模式产生了冲突。对于第一种上线模式来说，其实已经打破了A/B评测系统的基本假设，也就是全部用户都在一个系统（这个系统是既Exploit也Explore）中，于是也就没法知道这个系统的好坏（因为没有比较）。而对于第二种上线模式来说，虽然匹配A/B测试系统，但其实很难来评价说一个Bucket在Exploit，另外一个Bucket在Explore，这样的设置整体对系统的影响，因为在Explore的Bucket一般来说用户体验会降低，于是很难看出来这样做有什么好处。

其实这里的核心是，如何为E & E开发对照试验的问题。比较简单的一个思路是，我们至少需要四个Bucket。一组Bucket A1 + A2是一个系统相应的Exploit和Explore，另外一组Bucket B1 + B2是另外一个系统相应的Exploit和Explore。那么在比较Bucket Performance，我们需要综合比较(A1 + A2)和（B1 + B2）。当然，这只是一个非常粗浅的方案，依然会有细节问题，取决于具体的系统和产品。

### 难点三：如何平衡产品
***
通过前面两个难点可以看出，E & E**几乎一定**会导致产品的用户体验下降，至少在短期内。如何弥补这一点，技术上其实比较困难。比如做Deepak那样的过滤是一种思路，那就是只在优质内容里Explore。当然，有人会说，这样其实也没有多大的意义。然而，一旦把质量的闸门打开了，那就会对用户体验带来很大的影响。

这也是很多产品经理对于E & E非常谨慎的原因。能不做就不做。而且，在牺牲了用户体验的结果后，E & E所带来的好处其实很难评测，这主要是线上产品的评测机制和评测原理所决定的。目前还没有比较统一的解决方案。如何能够做到“用户友好型”E & E呢？

这里面可以有两种思路：

1. 不是所有人群的所有访问都适合做Exploration。但是和传统的E & E不同的是，做“反向E & E”。也就是说，我们只针对非常Engaged的人做Exploration，而并不是新用户或者是还没有那么Engaged的人群。这个思路是和现在E & E完全相反，但是更加人性化。
1. 夹带“私货”。也就是更改E & E的算法，使得高质量的内容和低质量的内容能够相伴产生，并且高质量的内容更有几率排在前面。这样用户体验的损失可控。这个思路我们在<sub>[7]</sub>里有所尝试，效果不错。

其实，E & E和产品的结合点应该是工程和研究的重点，但很遗憾的是，碍于数据和其他方面的因素，这方面的研究工作几乎没有。

## 结论
***

本篇文章讨论了推荐系统中Exploitation和Exploration的使用，分享了这方面的历史，探讨了工程和产品的技术难点，希望这篇文章能够为相关方向抛砖引玉。


## 参考文献
***
1. Lihong Li, Wei Chu, John Langford, and Robert E. Schapire. **A Contextual-Bandit Approach to Personalized News Article Recommendation**. In Proceedings of WWW 2010.
1. Deepak Agarwal, Bee-Chung Chen, Pradheep Elango. **Explore/Exploit Schemes for Web Content Optimization**. In Proceedings of ICDM 2009.
1. John Langford, Alexander Strehl, and Jennifer Wortman. **Exploration Scavenging**. In Proceedings of ICML 2008.
1. Lihong Li, Wei Chu, John Langford, and Xuanhui Wang. **Unbiased Offline Evaluation of Contextual-Bandit-Based News Article Recommendation Algorithms**. In Proceedings of WSDM 2011.
1. Lihong Li. **Offline Evaluation and Optimization for Interactive Systems**。 In Proceedings of WSDM 2015.
1. Deepak Agarwal. **Recommending Items to Users: An Explore/Exploit Perspective**. In Proceedings of the 1st Workshop on User Engagement Optimization at CIKM 2013.
1. Liangjie Hong and Adnan Boz. **An Unbiased Data Collection and Content Exploitation/Exploration Strategy for Personalization**. ArXiv. 2016.
