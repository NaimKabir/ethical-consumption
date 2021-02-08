# ethical-consumption

`ethical-consumption` is a service for linking consumption with ethical corporate behavior. Consumers should give bad actors less revenue, and should give good actors with good product more revenue.

## Purpose: A Moral Economy

The promise of capitalism remains unfulfilled. Perfect allocation of consumer dollars towards goods and services is meant to reflect social values in our production systems and supply chains, but unethical behavior is rarely punished when we vote with our dollars.

You never know what heinous company is buried deep in the supply chain for your cup of coffee or your tennis shoes, so  you couldn't boycott them even if you wanted to. There is an information barrier that keeps us from bridging the gap between our moral compasses and where our money goes.

We can change that.

As of 2019, [~14% of purchases were made online.](https://www.statista.com/statistics/534123/e-commerce-share-of-retail-sales-worldwide/) This number is only expected to grow as time goes on. A monitor built directly into browsers that can help us determine moral purchases from immoral ones can help us sleep easier—but with enough of us it will begin to move mountains. 

## How we make money

Any labor is bound to be steered by where the money comes from. That's the entire premise of this service, after all.

So how can you trust this service to give you the right information while it's somehow taking in revenue?

Well, you shouldn't. Instead, you should inspect the project and see if you can become convinced, yourself. I can give you a few reasons to trust it:

1. The project's code is public and transparent, and will be for its entire lifecycle. If we do hidden things like share data without consent or nonsense like that, you'll know—because we'll be the victims of our own platform.
2. Content changes can't be invoked by the companies being scrutinized by the service. All reported ethical behaviors are either community-sourced or reported by official, public, and auditable agencies.
3. We'll make conscious effort to align revenue streams with the desires and well-being of our members. If we make mistakes, we expect members to be pretty loud about telling us.

It's always kind of a balancing act figuring out how to do good while also doing well, but right now potential monetization options look like they'll be some combination of:
1. **Subscription-based usage:** Ask for some low monthly rate to keep access to the service's functions. A lot of people are interested in ethical consumption, but it's still not really known whether or not folks care enough to pay for the luxury of not having to think about what they buy.
2. **Lead-generation for companies:** Since using the platform requires members to explicitly state what moral stances they care about, we can easily "matchmake" between members and companies that might want to advertise to them. This would involve doing data-sharing, and we'd ask for consent first.
3. **Donation box:** Wikipedia has been keeping their servers up for years, and as far as I can tell, their only revenue stream is from die-hard donors who understand what a valuable service it is, and how costly it can be to serve content. This might work for us too.
4. **Affiliate links:** If we know what you're trying to buy and you don't have options from an ethical company, we can look for ethical substitutes and recommend them to you via affiliate links, where companies give us some premium for the advertising. The issue with this is we need some guardrails to ensure that the companies we suggest match your ethical stances (and aren't just any ol' bullshit corporation with an affiliate program that would give us money).
5. **Grant funding:** We can look into getting a no-strings-attached cash grant. These would likely be government (and thus taxpayer funded), incentivizing the project to work towards a "public good" most directly. However this isn't sustainable and could pressure the project if the grant funders had demands for subsequent rounds of funding.

Unfortunately I can't just make the service free, because hosting services on the web is expensive (especially if it's used frequently). Making money is always going to be a concern for me–so it'll be a concern for you, too.

## Usage

1. Install the Chrome extension by visiting [PLACEHOLDER].
2. Use the default list of ethical positions, or select each tag that aligns with your personal ethics.
3. Visit the checkout page of various e-commerce platforms with products in your cart. A warning message will appear if we've detected that any of the products were made by companies that violate your values anywhere in their supply chains.

## Community

The mapping between products, companies, and objective reporting on ethical or unethical behavior is painstakingly maintained by a dedicated community. Though, to start, the editing community will be restricted to a dedicated and selective few, it is designed to be a community effort where we collectively maintain the truth on corporate behaviors.

The community operates on purchasepedia.org, a site powered by open-source [MediaWiki](https://www.mediawiki.org/wiki/MediaWiki) technology (just like Wikipedia). Using the native abstraction of `Category` labels to tag company pages with various ethical deeds and misdeeds, our group of volunteer editors powers moral purchasing habits.

# Development

The development server can be started with:

`dc up`

This will set up database tables and a Wiki as well. (Any 'secrets' or passwords used tp set up local development Wiki are for local use only--none are used for production.)

The Wiki is can be accessed at `localhost:8080` and has basic [MediaWiki](https://www.mediawiki.org/wiki/MediaWiki) functionality.

The development server can be taken down with:

`dc down`