---
layout: post
title:  Microservices and Boundaries
date: 2015-09-29T13:30:00-06:00
comments: true
author: donald_belcham
---
One of the most common questions I’ve been getting asked about microservices is “How big?” I was recently down in Montevideo Uruguay speaking at the [.NetConf UY](www.netconf.uy) Meetup speaking about microservices. As part of my vacation in Uruguay I wanted to get a local SIM card for my phone so that I would have data without relying on free WiFi. At the time I was getting the SIM and making things work it seemed like one of the most frustrating experiences I’ve ever had. Lots of running around, lots of wasted time. Once I got onto the plane home I started thinking about it in a different light.

Here’s the process I went through to get data on a SIM.

![Antel](http://farm6.staticflickr.com/5737/21313922360_6daa6624d8_m.jpg)

First I went to an [ANTEL](http://www.antel.com.uy/antel/ "") store. ANTEL is the state owned telecom. It’s cheap, but like any good state company it has bureaucracy. I went into the store and the first stop is a concierge/secretary desk. Once I explained, through bad spanish and worse charades, what I wanted I was told that they would need my passport. Of course I didn’t have it so it was back to the hotel to get a passport. Back at the ANTEL store there was, of course, a new person manning the front desk so it was more bad spanish and Italian inspired charades. My request was understood and I was given a number and told to wait (Uruguay *loves* its number dispensers). About 5 minutes later I was called to a desk and the process of signing up begins. 

After some furious keyboard smashing, and more horrible spanish on my part, I was told to go to the cashier to pay. I went across the lobby (really it’s all just one big room) and waited in line for the guy working the cashier wicket to finish with his mobile phone. I walk up and brutalize his native tongue. He looks at me, spins his chair around and pulls some paper off the printer. More furious keyboard smashing, a test of my rudimentary understanding of numbers in spanish and my payment was made. The hands me some paper and points me to another line and another wicket.

I line up once again and was called to the counter. I handed over the paperwork, the lady disappeared into the back room and re-appeared with the SIM card. A brief explanation of the phone number and security code and I was told I was done there. So I headed back over to the original gentleman that was helping me. At that point I was told that I was finished.

The SIM card went into the phone and I was connected to the ANTEL network…except I had no service. I couldn’t text, call or use data. I went back to the hotel where I had WiFi figuring that I needed to simply tweak some settings for the APN. An hour later I had changed the APN and still had nothing. At this point I gave up and called my friends at [Kaizen Softworks](http://www.kzsoftworks.com/ ""). Within a minute I was told that I needed to go visit a place called Abitab. Once there we could charge our phone number with money. So off I go to the local Abitab (which I luckily knew about since I changed money at it earlier in the day).

![Abitab](http://farm6.staticflickr.com/5691/21490886762_0d42a67d7b_m.jpg)

I get to Abitab, go to a wicket, show them the paperwork with my phone number on it, tell them I want to put 400 pesos on the account and 3 minutes later I’m done. So now I have a SIM card, it has funds, but I still don’t have service. I needed to request a “plan” to use. Luckily when I was sitting in the hotel trying to figure out how to get service I found the magic code to do that. So I send an SMS to a predetermined number and boom….internet access.

There were a lot of steps in that process. More than what was needed some might say. If you think about it, there are good separation of concerns and lessons for microservices here. Let’s take a look at the process a different way.

ANTEL provides telecom services. I was a consumer (UI if you will) in need of those services so I reached out to their endpoints. From 40,000 feet this is a pretty standard microservice interaction. The first thing that the microservice required is that I authenticate myself (provide a passport). Once I’ve done that they start the process of creating a client record for me and putting in the purchase order for the SIM card. This is a pretty straight forward synchronous operation. In essence this is the code that runs in the controller of your REST WebAPI endpoint.

![Image1](http://farm1.staticflickr.com/584/21817801705_5f577c2843_n.jpg)

When the purchase order is successfully created anyone that cares is notified. In this case the cashier is notified by having a print out appear on his printer. I’m also notified that I need to go to a new location to do more ‘stuff’. In technical terms an event was published onto some kind of service bus. The cashier subscribed to that event type and printed a purchase order. The original service that I contacted provided a URI as part of its result to me that I needed to navigate to. That URI pointed me to the cashier service.

Once I made payment to the cashier service it published a successful payment event onto a service bus. The cashier service also provided me with a URI to visit to get the SIM card, which was the new line-up. The fulfillment service listened to that event and when I made my request to them they provided me with the SIM card and a bunch of meta data to go with it.

Like a good little consumer (UI) I made a call final call to an endpoint (the original person I dealt with) to check to see if my transaction was complete.

After dealing with ANTEL I moved on to Abitab, or the payment services. I called on one of their endpoints to make a payment. Again, I need to provide “proof” of who I am. In this case the level of proof is lower; I only need to provide the account number I want to deposit money to. The fact is, I can deposit money to any account I want and the service isn’t going to complain. It’s not hurting anyone but me if I do it wrong. So to make this payment I provided the amount of the payment, the means of payment and the account the payment should be applied to. I got a receipt. That concludes my interaction with the payment service.

Behind the scenes the Abitab service sent a message to some ANTEL service that notified ANTEL that the account needed to have credit applied to it and how much that credit should be. This is a service-to-service communication. Abitab knows nothing about the functionality of Antel. All Abitab does is publish a message that an event (payment) occurred. Abitab doesn’t need to know if, when, or how Antel applies the credit to the account so there is no need for a confirmation message so it can use a messaging pattern effectively here.

![Image2](http://farm1.staticflickr.com/641/21817803695_c8444f341e_n.jpg)

The separations of concerns in this case was very clear. One microservice (company) was responsible for all things phone related (SIM card, activation, etc) and another microservice was responsible for payments. If you’ve dealt with a system like this (Antel and Abitab) you’ll know that there are some significant benefits from this separation. First, and foremost, you can pay anything imaginable at Abitab. Need to pay your water bill? Go to Abitab. You TV bill? Go to Abitab. All Abitab does is take the payment and send a message to the company concerned tell them that a payment has been received. 

When you’re writing microservices you need to look at the responsibilities and concerns of the services.  They need to be well encapsulated but also single-y responsible. If it feels like one microservice needs the functionality of another, look at ways to communicate between them. Ideally this communication should be unidirectional and in the form of commands. By taking this approach you will create microservices that do not effect each other in deployment, down(up)-time or changes.
 
