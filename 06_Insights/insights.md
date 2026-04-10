*Insights will go here.*




-- 7. PRICE SANITY CHECK

        "Economic Pulse Check." As a Senior Analyst, I never trust a mean (average) without seeing the min and max first. A single "fat-finger" error—like someone accidentally listing a $10 cable for $10,000—will completely hallucinate your revenue projections and skew your entire analysis.
        
        1. The Outlier Investigation (MAX values)
            If your max_price is significantly higher (e.g., 50x) than your avg_price, you have Outliers.

            Business Insight: Are these "Lush" luxury items that drive our brand, or are they wholesale bulk orders?

            Senior Action: When we move to Power BI, we might need to use a Median instead of an Average to represent the "typical" customer experience, as the average will be "dragged" up by these expensive items.

        2. The "Freight Burden" (AVG freight)
            Compare your avg_freight to your avg_price.

            The Ratio: If freight is consistently more than 20–30% of the item price, your business has a Logistics Problem. High shipping-to-price ratios are the #1 cause of cart abandonment.

            Senior Action: We’ll eventually create a "Freight Ratio" column to see which regions or categories are the most expensive to serve.

        3. The "System Glitch" Check (zero_or_neg_price)
            Price <= 0: Unless AuraTech has an intentional "Free Gift" program, a price of 0 is a data entry failure.

            Negative Freight: This is a major red flag. Shipping costs the company money; it shouldn't be a "credit" unless it’s a refund being recorded incorrectly in the wrong table.

