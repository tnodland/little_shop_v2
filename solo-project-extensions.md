# Little Shop Extensions

These "extension" stories are for the final week solo project for Backend Module 2 students. It assumes your team has already completed 100% of the Little Shop project. In the case that your team has not finished the project, instructors will provide an alternate code base.

Choose 2 stories of extension work, and instructors will do their best to accommodate both of your choices. Try to pick one story that plays to your strengths, and one story that will help an area of growth for yourself.

Below, you'll see Completion Criteria and Implementation Guidelines. The Completion Criteria are the points that instructors will be assessing to ensure you've completed the work. The Implementation Guidelines will direct you in how to implement the work or offer advice or restrictions.

You get to choose how to implement the story, presentation, routing, etc, as long as your work satisfies the Completion Criteria.


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



```
 "SELECT users.name, users.email,
 SUM(order_items.quantity * order_items.ordered_price) AS total_revenue,
 SUM(
   CASE
    WHEN items.merchant_id = 1084
      THEN (order_items.quantity * order_items.ordered_price)
    ELSE
      null
   END
  ) AS merchant_revenue
  FROM users
  INNER JOIN orders ON orders.user_id = users.id
  INNER JOIN order_items ON order_items.order_id = orders.id
  INNER JOIN items ON items.id = order_items.item_id
  WHERE (orders.status = 2) AND (users.id = 1093)
  GROUP BY users.id"

 ```
