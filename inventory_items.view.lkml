view: inventory_items {
  sql_table_name: PUBLIC.INVENTORY_ITEMS ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension: product_brand {
    type: string
    sql: ${TABLE}."PRODUCT_BRAND" ;;
  }

  dimension: product_category {
    type: string
    sql: ${TABLE}."PRODUCT_CATEGORY" ;;
  }

  dimension: product_department {
    type: string
    sql: ${TABLE}."PRODUCT_DEPARTMENT" ;;
  }

  dimension: product_distribution_center_id {
    type: number
    sql: ${TABLE}."PRODUCT_DISTRIBUTION_CENTER_ID" ;;
  }

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."PRODUCT_ID" ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}."PRODUCT_NAME" ;;
  }

  dimension: product_retail_price {
    type: number
    sql: ${TABLE}."PRODUCT_RETAIL_PRICE" ;;
  }

  dimension: product_sku {
    type: string
    sql: ${TABLE}."PRODUCT_SKU" ;;
  }

  dimension_group: sold {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."SOLD_AT" ;;
  }

  measure: cost {
    type: number
    sql: ${TABLE}."COST" ;;
    value_format_name: usd_0
  }

  measure: total_cost {
    label: "Total Cost"
    description: "sum of Cost in USD format"
    type: sum
    sql: ${TABLE}.cost ;;
    value_format_name: usd_0
  }

  measure: total_product_cost {
    label: "Total Unique Product Cost"
    description: "Total Unique Products Cost by Product ID"
    type: sum_distinct
    sql_distinct_key: ${product_id} ;;
    sql: ${TABLE}.cost ;;
    value_format_name: usd_0
  }

  measure: count {
    type: count
    drill_fields: [id, product_name, products.id, products.name, order_items.count]
  }
}
