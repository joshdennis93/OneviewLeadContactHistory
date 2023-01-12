# OneviewLeadContactHistory
View the field audit history of a Contact record as well as the Lead it was converted from in a single component. No need for awkward reporting or complex customised solutions, as this plugs straight into your existing Lead/Contact field history configuration.

## Installation
1. Clone/download files in repo
2. Use your favourite metadata management tool to add them to your current metadata and push to your org.
3. Add to Contact object lightning page via Lightning App Builder or a Screen flow.
4. If you haven't already, set Lead/Contact object field history via the Setup/Object Manager menu. The component will only show the field history of fields you have previously tracked for audit, so don't freak out if you aren't viewing any history initially!

## Limitations/Defects
- There's no pagination, so if you have a Lead/Contact with 50 status changes across its lifespan, you'll have a very long list.
- If you have edited the record & expect new entries to appear, you will need to refresh the page to see them. Reactivity can be added (I think) by using a wire adaptor to re-query the Apex controller similarly to what I did here: https://github.com/joshdennis93/DataCompletionCard/blob/main/force-app/main/default/lwc/dataCompletionCard/dataCompletionCard.js.
- In a perfect world, this would probably (optionally) also include Account updates & possibly even Opportunities. The quantity of data to display could make it a UX/performance nightmare, but with some intelligent querying and UI design (tree lists?), you could make something workable.
- You cannot sort/filter the rows. Sorting isn't too difficult & is documented on the LWC datatable component documentation.

## Examples
![image1](/images/image1.png)

![image2](/images/image2.png)

![image3](/images/image3.png)

## Use cases
- Fairly straightforward - for a given Contact that had been converted from a Lead, you can view the changes made to it as a Lead without needing to query for/report on the Lead itself.
