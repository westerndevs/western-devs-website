
---
layout: post
title: The Code Review Blues
date: 2016-08-03 16:13:00
tags:
  - code reviews
excerpt: Code reviews. Some people really enjoy participating in them. Others find it worse than a visit to the dentist. I've been in both camps.
authorId: lori_lalonde
originalurl: http://solola.ca/the-code-review-blues/
---

Code reviews. When incorporated as part of the development process, they may be carried out by a senior level professional (i.e. an architect, team lead, or dev manager), or by multiple developers on your team.  Sometimes you may go through rounds of peer reviews before the code is reviewed by a senior member for final approval.

Often reviews have been conducted with the developer and reviewer sitting side by side, having a discussion about the areas that could use improvement, identifying any use cases or logic that was missing.

Nowadays, just as with everything else, this communication has shifted to an online system, such as , which enable reviewers to highlight code and enter comments against it. Developers can reply to those comments if further explanations are needed to justify a coding approach. Additionally, they can make the requested changes and check it back in for another round of reviews.

Some people really enjoy participating in code reviews. Others find it worse than a visit to the dentist. I've been in both camps.  

**When it's done well…**

I have participated in many code reviews during my career, both as code author and reviewer. In the majority of those situations, it was a positive experience. I was fortunate enough to interact with reviewers that were supportive and encouraging. Often they provided constructive feedback on how I could improve the code. When that happened, I walked away from the process feeling more confident in myself and my skills because I learned something new that I would apply to my coding practice going forward.

In situations where I was reviewing someone else's code, the developer was receptive to the feedback, and appreciated the encouraging remarks I would make about his/her coding efforts as well. These positive experiences compounded over time which brought the team together, and strengthened the working relationships among team members. It resulted in a happy, cohesive, and productive team.

**When things go South…**

There have been the rare occasions where the process was mired in friction, creating a rift on the team. In some cases, code reviews were used as a tool for the reviewer to chastise developers, exert authority, or cater to an obsessive compulsive nature over code styles. In other scenarios, the code author was simply unwilling to participate in the code review process in a constructive manner.

Let me explain.

**_Code Shaming_**

In one case, I worked on a team with an architect who used the code review process to scold developers for coding practices that did not align with his views. He decided to impose his will on the team if anyone disagreed or countered his code review suggestions, regardless of how sound the counter argument was. The more comments he added during the review process, the more his comments became aggressive in nature. Oftentimes, the comments were just repetitive pointing out the same "misdeeds" over and over again.

In this situation, there is no sense of collaboration, togetherness, team work, or respect for any other team member's views. Team members that are subject to this form of code shaming end up feeling deflated and their self-confidence shaken. This is a situation that eventually drives down the team morale, and overall productivity suffers. Eventually, the team may experience a high turnover rate.

**_Extreme Code Formatting _**

In another scenario, a senior team member's obsessive compulsive nature resulted in busy work for his team members. His main pet peeves were the use of tabs instead of spaces, opening brackets being on the same line as the method or property signature, and other non-trivial items that did not contribute to code quality. I understand the need for uniformity, but these are areas that waste the developer's time. The good news here is that this problem is easily solved through the use of code formatting tools that will get the job done automatically when saving changes to your solution files.

If you are working with team members who strive for code formatting perfection, then I recommend that each member of the team make use of one of the many available IDE extensions available, such as [Code Maid](http://www.codemaid.net/) or [Resharper](http://www.jetbrains.com/resharper/features/code_formatting.html).

**_Unreceptive to Feedback_**

As a code reviewer, I have also encountered negative experiences from a team member who was not open to receiving feedback. The code review process seemed to be a source of stress and annoyance for him. In one instance, I highlighted a potential audit issue as a result of his commit, and asked him to correct it.

What was the issue?

Rather than making a simple code change to an existing class, he decided it was more efficient to copy the code into a new class, make the necessary changes, and delete the original class. This resulted in the deletion of the source code history on that file. When I advised him that deleting source code history was a potential audit issue, he did not receive that feedback with an open mind.

Instead of participating in the code review process in a constructive manner, he shrugged off my feedback with responses like "Why does it matter?", "Nobody cares about keeping the history on that one class anyway", "You just want to be right", and so on and so forth.

Considering the work being done was for a large financial institution, where audit trails are a high priority, this was a red flag and I could not let this one slide. Eventually, he conceded to make the change, but this event was the catalyst for another situation I was not expecting.

**_Merge Conflict Avoidance_**

On that same project, we were required to perform peer code reviews by commenting on each other's pull requests. Once the code passed the review process, the reviewer would be responsible for merging the pull request to master.

This was an opportunity that one team member leveraged to his advantage in order to place the burden of dealing with any merge conflicts on the remaining team members. He refused to merge other pull requests unless his pull request was merged first. There was an instance where he insisted on his pull request being merged first when he did not even have a pull request submitted at the time. When I pointed that out, he tried to save face with a reply of: "It's coming." A day and a half later, he finally had a pull request to review, while the other pull request sat in limbo.

As the project progressed, this type of behaviour drove the morale of the team down to an all-time low and productivity stagnated.

**The Problems (and some suggested solutions)**

Yes, that's problem**_s_**, with an "s". There isn't one factor that contributes to the Code Review Blues. It's a combination of many.

**_Different Expectations_**

The main source of friction during the code review process stems from team members' differing expectations on the code review's intended purpose and end result. At a minimum, code reviewers should verify the code is functional, scalable, extensible, maintainable, and secure.

The following [tweet](https://twitter.com/bliss_ai/status/753635662792982530) from [@bliss_ai](https://twitter.com/bliss_ai) is a good starting point on questions you should ask yourself, and discuss with your team, as both code author and reviewer:

![](http://solola.ca/wp-content/uploads/2016/08/CodeReviewTweet_Bliss_Ai.png)

 

When introducing a code review process to your organization, it is ideal to gather your development team into a room to discuss how this will impact the team. This is also an opportunity to educate the team on effective code review practices, and provide proper training on how the code review tool should be used.

This is also an excellent opportunity to answer the following questions:

1. What is the main purpose and desired end result for the code review process?
2. What is the minimum set of criteria that must be met in order to pass a code review?
3. How will the code review process change each team member's day-to-day task assignments?
4. What percentage of time will be allocated into the team's project plan for code reviews?
5. Will their participation as code reviewers be held to the same standard as their other deliverables (i.e. will the value they bring to the code review process be rewarded and recognized)?

This training should also be included in the new hire on-boarding process.

**_Poor Communication and/or Interpersonal Skills_**

Senior members that are in a position of authority may have been promoted through the ranks due to strong technical skills, but they might be a little rough around the edges when it comes to communication and/or interpersonal skills.  If code reviews with a specific member become a source of contention for the entire team, it might be time to recommend soft skills training for that team member.

If you're not convinced that soft skills are worth investing in, take the time to read this short article, "[Why Soft Skills Matter – Making Your Hard Skills Shine](https://www.mindtools.com/pages/article/newCDV_34.htm)" by MindTools.

**_Misinterpretation_**

It's never easy to critique someone else's work nor to be on the receiving end of the type of scrutiny code reviews require.

If the feedback you provided is valid and communicated with good intentions, but not well received by the code author, this may be the cause of a deeper, underlying issue. A team member may be resistant to feedback on their code changes because they perceive it to be a personal attack.

If you find yourself getting into a heated exchange with someone who takes offense to the feedback provided, take a step back and analyze the form of communication being used. Think about the following points before you proceed with the review:

1. Are you relying on an online code review tool as the sole mechanism to provide feedback? If so, is it possible that the tone of the feedback is being misconstrued by the code author?
2. Do you start or end the review process with face-to-face communication?
3. Do you also highlight areas that were done really well or is the feedback only focused on what needs to be changed?

In this situation, you may need to experiment with different communication and feedback styles to find an approach to which your colleague is open and receptive. If all else fails, seek advice from a senior level manager.

**Final Thoughts**

Code reviews are intended to start a conversation about code quality, where all parties emerge from the other side having learned something – whether it is about improving a section of code, adopting better coding practices, or reaching an understanding on the current approach taken.

Everyone should feel confident once the code review process has come to a close that the code submitted performs what it was intended while meeting a defined level of quality.

The code author and reviewer(s) should feel good about the work they are producing, should feel encouraged by the support they receive from each member on the team, and should come out of it with their self-respect and dignity intact.

 

_*Special thanks to [Donald Belcham](https://twitter.com/dbelcham) and [Shane Courtrille](https://twitter.com/shanecourtrille) for reviewing and providing valuable feedback which contributed to the overall quality of this post._


  