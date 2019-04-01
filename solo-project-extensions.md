# Little Shop Extensions

These "extension" stories are for the final week solo project for Backend Module 2 students. It assumes your team has already completed 100% of the Little Shop project. In the case that your team has not finished the project, instructors will provide an alternate code base.

Choose 2 stories of extension work, and instructors will do their best to accommodate both of your choices. Try to pick one story that plays to your strengths, and one story that will help an area of growth for yourself.

Below, you'll see Completion Criteria and Implementation Guidelines. The Completion Criteria are the points that instructors will be assessing to ensure you've completed the work. The Implementation Guidelines will direct you in how to implement the work or offer advice or restrictions.

You get to choose how to implement the story, presentation, routing, etc, as long as your work satisfies the Completion Criteria.

---

## Users can rate items

#### General Goal

Users will have the ability to leave ratings for items they have successfully purchased.

#### Completion Criteria

1. Users can write one review for each item in any "completed" order.
1. Ratings will include a title, a description, and an integer rating from 1 to 5, a user, an item, and timestamps.
1. Users will have a link on their Profile to an index page to see all reviews they have written. That index page will give them the ability to edit or delete any review. Users cannot add reviews from this page.
1. Users will navigate to one of their order show pages where each item will have a button or link to add a review if a review is possible.
1. If a user orders the same item in a different order, they get to leave an additional review. (if they order the same item in 4 different orders, they get to leave 4 ratings)
1. The average review rating for each item should be shown on both the Item Catalog page as well as its Item Show page.
1. The Item Show page will show all reviews for that item including the name of the reviewer and all details of the review including the date it was created; if the review was changed, also show the updated_at date.

#### Implementation Guidelines

1. No "show page" is required for reviews; reviews will be displayed on each Item's show page.
1. An order show page should not show a link to create a review for an item if the user cannot review that item any more. Consider building a `reviewable?` helper method to check.
1. Reviews do not need to be tied to a specific order.

#### Mod 2 Learning Goals reflected:

- Database relationships
- Rails development (including routing)
- Software Testing
- HTML/CSS styling and layout

---

## Slugs

#### General Goal

All paths for users and items should change from `/users/5` or `/items/17` to use "slugs" such as `/admin/user/user2000-gmail.com` or `/items/awesome-widget-2000`.

#### Completion Criteria

1. The User model and Item model need an additional string field to contain the slug.
1. The User slug is built from the user's email address.
1. The Item slug is based on the name of the item, plus a numeric value ONLY if the item name is not unique. You may choose to use a randomized number, or the ID of the item. eg, if "Widget" is item 17 in the database, its slug could be 'widget-17'.
1. Do not use any third-party gems to complete this work.

#### Implementation Guidelines

1. The slug string should ONLY be changed when the user's email address, or the item name, is changed.
1. No other alteration of the user or item record (eg, enabling/disabling a user or item, or adjusting an item's inventory) should generate a new slug. Be sure to include tests that ensure the slug does not change under these conditions, especially if you're using a random number.

#### Mod 2 Learning Goals reflected:

- Database migrations
- ActiveRecord
- Rails routing
- Software Testing

---

## Users have multiple addresses

#### General Goal

Users will have more than one address associated with their profile. Each address will have a nickname like "home" or "work". Users will choose an address when checking out.

#### Completion Criteria

1. When a user registers they will still provide an address, this will become their first address entry in the database and nicknamed "home".
1. Users need full CRUD ability for addresses from their Profile page.
1. An address cannot be deleted or changed if it's been used in a "completed" order.
1. When a user checks out on the cart show page, they will have the ability to choose one of their addresses where they'd like the order shipped.
1. If a user deletes all of their addresses, they cannot check out and see an error telling them they need to add an address first. This should link to a page where they add an address.
1. If an order is still pending, the user can change to which address they want their items shipped.

#### Implementation Guidelines

1. Every order show page should display the chosen shipping address.
1. Statistics related to city/state should still work as before.

#### Mod 2 Learning Goals reflected:

- Database relationships
- ActiveRecord
- Software Testing

---

## More Merchant Stats

#### General Goal

Build a Merchant leaderboard as part of the "/merchants" page containing additional statistics that all users can see.

#### Completion criteria

1. Add the following leaderboard items:
  - Top 10 Merchants who sold the most items this month
  - Top 10 Merchants who sold the most items last month
  - Top 10 Merchants who fulfilled non-cancelled orders this month
  - Top 10 Merchants who fulfilled non-cancelled orders last month

2. When logged in as a user, the following stats are also displayed on the "/merchants" page as well:
  - Also see top 5 merchants who have fulfilled items the fastest to my state
  - Also see top 5 merchants who have fulfilled items the fastest to my city

#### Implementation Guidelines

1. It may be tricky to build any one portion of these statistics in a single ActiveRecord call. You can use multiple calls in a method to build these statistics, but allow the database to do the calculations, not Ruby.

#### Mod 2 Learning Goals reflected:

- Advanced ActiveRecord
- Software Testing
- HTML/CSS layout and styling

---

## Coupon Codes

#### General Goals

Merchants can generate coupon codes within the system.

#### Completion Criteria

1. Merchants have a link on their dashboard to manage their coupons.
1. Merchants have full CRUD functionality over their coupons with exceptions mentioned below:
  - merchants cannot delete a coupon that has been used
  - merchants can have a maximum of 5 coupons in the system
  - merchants can enable/disable coupon codes
1. A coupon will have a name, and either percent-off or dollar-off value. The name must be unique in the whole database.
1. Users need a way to add a coupon code when checking out. Only one coupon may be used per order.
1. Coupons can be used by multiple users, but may only be used one time per user.
1. If a coupon's dollar value ($10 off) exceeds the total cost of everything in the cart, the cart price is $0, it should not display a negative value.
1. A coupon code from a merchant only applies to items sold by that merchant.

#### Implementation Guidelines

1. Users can enter different coupon codes until they finish checking out, then their choice is final.
1. The cart show page should calculate subtotals and the grand total as usual, but also show a "discounted total".
1. Order show pages should display which coupon was used.
1. If a user adds a coupon code, they can continue shopping. The coupon code is still remembered when returning to the cart page.

#### Mod 2 Learning Goals reflected:

- Database relationships and migrations
- ActiveRecord
- Software Testing
- HTML/CSS layout and styling

---

## Bulk Discount

#### General Goals

Merchants add bulk discount rates for all of their inventory. These apply automatically in the shopping cart, and adjust the order_items price upon checkout.

#### Completion Criteria

1. Merchants need full CRUD functionality on bulk discounts, and will be accessed a link on the merchant's dashboard.
1. Bulk discounts can be one of two types: percentage based, or dollar based:
  - 5% discount on 20 or more items
  - $10 off an order of $50 or more
1. A merchant can have multiple bulk discounts in the system, but they must be the same percentage type or dollar type as the first bulk discount made.
1. When a user adds enough value or quantity of items to their cart, the bulk discount will automatically show up on the cart page.
1. A bulk discount from one merchant will only affect items from that merchant in the cart.
1. A bulk discount will only apply to items which exceed the minimum quantity specified in the bulk discount. (eg, a 5% off 5 items or more does not activate if a user is buying 1 quantity of 5 different items; if they raise the quantity of one item to 5, then the bulk discount is only applied to that one item, not all of the others as well)

#### Implementation Guidelines

1. If a merchant wants to change their discounts to a different type, they will need to delete all bulk discounts first.
1. When an order is created during checkout, try to adjust the price of the items in the order_items table.

#### Mod 2 Learning Goals reflected:

- Database relationships and migrations
- Advanced ActiveRecord
- Software Testing
- HTML/CSS layout and styling

---

## Downloadable Merchant User Lists

#### General Goals

On their dashboards, Merchants can access CSV-style data of their existing customers or users who have never bought from them ("potential customers").

#### Completion Criteria

1. The list of existing customers should generate 4 columns of data in a CSV format. Columns will include:
  - user name
  - email address
  - how much money they've spent on items sold by this merchant
  - how much money they've spent on items from all merchants
1. The list of potential customers should generate 4 columns of data in a CSV format. Columns will include:
  - user name
  - email address
  - how much money they've spent on items from all merchants
  - total number of orders made by this user
1. Deactivated users should not be included in these lists of data.
1. CSV data should sort users alphabetically by name.
1. Each user should be on a separate line in the CSV data.

#### Implementation Guidelines

1. Test this work very thoroughly at a model level
1. At a minimum, create a CSV view (make a view like existing_customers.csv.erb) and then `expect(page).to have_content()` should work well for feature tests; do not create an HTML-based view of the data.
1. Ideally, make the link to the CSV immediately download the CSV files; this complicates feature testing

#### Mod 2 Learning Goals reflected:

- Database relationships and migrations
- ActiveRecord
- Software Testing
- HTML/CSS layout and styling

---

## Merchant Statistics as Charts

#### General Goals

Convert statistics blocks on the application to visual charts using charting JavaScript libraries like D3, C3 or Google Charts, or find a Ruby gem that can assist.

#### Completion Criteria

1. Merchant dashboard page:
  - new: line graph or bar chart of total revenue by month for up to 12 months
  - existing: pie chart of the percentage of total inventory sold
  - existing: pie chart for top 3 states and top 3 cities
1. Merchant index page:
  - pie chart showing total sales on the whole site; merchants who are part of "completed" orders are shown on the pie chart
1. Use your discretion to add any additional charts where you see statistics on the site.

#### Implementation Guidelines

1. Feature testing charts is extremely hard; do your best to detect that a chart is present
1. Model testing will be extremely important to ensure data is coming back correctly
1. If you are also completing any other extension story which includes stats, try to implement some of that work in charts/graphs as well

#### Mod 2 Learning Goals reflected:

- Database relationships and migrations
- ActiveRecord
- Software Testing
- HTML/CSS layout and styling

---

## Merchant To-Do List

#### General Goals

Merchant dashboards will display a to-do list of tasks that need their attention.

#### Completion Criteria

1. Merchants should be shown a list of items which are using a placeholder image and encouraged to find an appropriate image instead; each item is a link to that item's edit form.
1. Merchants should see a statistic about unfulfilled items and the revenue impact. eg, "You have 5 unfulfilled orders worth $752.86"
1. Next to each order on their dashboard, Merchants should see a warning if an item quantity on that order exceeds their current inventory count.
1. If several orders exist for an item, and their summed quantity exceeds the Merchant's inventory for that item, a warning message is shown.

#### Implementation Guidelines

1. Make sure you are testing for all happy path and sad path scenarios.

#### Mod 2 Learning Goals reflected:

- MVC and Rails development
- Database relationships and migrations
- ActiveRecord
- Software Testing
