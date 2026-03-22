DROP TABLE IF EXISTS tableau_export;

CREATE TABLE tableau_export AS
WITH
/* 1) Clean/cast File A */
a AS (
  SELECT
    date,
    channel,
    CAST(revenue AS REAL)      AS revenue,
    CAST(conversions AS REAL)  AS conversions,
    CAST(clicks AS REAL)       AS clicks,
    CAST(impressions AS REAL)  AS impressions,
    type
  FROM file_a
),

/* 2) Clean/cast File B */
b AS (
  SELECT
    date,
    channel,
    CAST(spend AS REAL) AS spend
  FROM file_b
),

/* 3) Join A + B on date + channel */
ab AS (
  SELECT
    a.date,
    a.channel,
    a.type,
    a.revenue,
    a.conversions,
    a.clicks,
    a.impressions,
    b.spend
  FROM a
  LEFT JOIN b
    ON a.date = b.date
   AND a.channel = b.channel
),

/* 4) Aggregate File C by date + customer_type (customer revenue only) */
c AS (
  SELECT
    date,
    customer_type,
    SUM(CAST(revenue AS REAL)) AS customer_revenue
  FROM file_c
  GROUP BY date, customer_type
),

/* 5) Base (wide) dataset: Total + Customer rows */
base AS (
  /* TOTAL rows */
  SELECT
    ab.date,
    ab.channel,
    ab.type,

    ab.revenue,
    ab.conversions,
    ab.clicks,
    ab.impressions,

    /* Spend: Organic = 0; otherwise spend (NULL -> 0) */
    CASE
      WHEN ab.channel = 'Organic' THEN 0.0
      ELSE COALESCE(ab.spend, 0.0)
    END AS spend,

    ''   AS customer_type,   -- blank instead of "Total"
    0.0  AS customer_revenue,

    /* CTR: clicks / impressions */
    (ab.clicks * 1.0) / NULLIF(ab.impressions, 0) AS CTR,

    /* CVR: conversions / clicks */
    (ab.conversions * 1.0) / NULLIF(ab.clicks, 0) AS CVR,

    /* CPM: (spend / impressions) * 1000 */
    (
      (CASE
         WHEN ab.channel = 'Organic' THEN 0.0
         ELSE COALESCE(ab.spend, 0.0)
       END) * 1.0
    ) / NULLIF(ab.impressions, 0) * 1000 AS CPM,

    /* eCPM: (revenue / impressions) * 1000 */
    (ab.revenue * 1.0) / NULLIF(ab.impressions, 0) * 1000 AS eCPM,

    'Total' AS data_set
  FROM ab

  UNION ALL

  /* CUSTOMER rows */
  SELECT
    c.date,
    ''   AS channel,
    ''   AS type,

    0.0  AS revenue,
    0.0  AS conversions,
    0.0  AS clicks,
    0.0  AS impressions,
    0.0  AS spend,

    c.customer_type,
    c.customer_revenue,

    0.0  AS CTR,
    0.0  AS CVR,
    0.0  AS CPM,
    0.0  AS eCPM,

    'Customer' AS data_set
  FROM c
)

/* 6) UNPIVOT to long format:
      - metric / metric_value for: revenue, conversions, clicks, impressions, CTR, CVR
      - cost_metric / cost_metric_value for: CPM, eCPM
*/
SELECT
  date,
  channel,
  type,
  spend,
  customer_type,
  customer_revenue,
  data_set,

  'revenue' AS metric,
  revenue   AS metric_value,

  ''        AS cost_metric,
  0.0       AS cost_metric_value
FROM base

UNION ALL
SELECT date, channel, type, spend, customer_type, customer_revenue, data_set,
  'conversions', conversions,
  '', 0.0
FROM base

UNION ALL
SELECT date, channel, type, spend, customer_type, customer_revenue, data_set,
  'clicks', clicks,
  '', 0.0
FROM base

UNION ALL
SELECT date, channel, type, spend, customer_type, customer_revenue, data_set,
  'impressions', impressions,
  '', 0.0
FROM base

UNION ALL
SELECT date, channel, type, spend, customer_type, customer_revenue, data_set,
  'CTR', CTR,
  '', 0.0
FROM base

UNION ALL
SELECT date, channel, type, spend, customer_type, customer_revenue, data_set,
  'CVR', CVR,
  '', 0.0
FROM base

UNION ALL
SELECT date, channel, type, spend, customer_type, customer_revenue, data_set,
  '', 0.0,
  'CPM', CPM
FROM base

UNION ALL
SELECT date, channel, type, spend, customer_type, customer_revenue, data_set,
  '', 0.0,
  'eCPM', eCPM
FROM base
;

SELECT *
FROM tableau_export;
