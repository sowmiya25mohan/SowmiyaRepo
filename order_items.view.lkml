view: order_items {
  sql_table_name: PUBLIC.ORDER_ITEMS ;;

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

  dimension_group: delivered {
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
    sql: ${TABLE}."DELIVERED_AT" ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension_group: returned {
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
    sql: ${TABLE}."RETURNED_AT" ;;
  }

  measure: sales {
    type: number
    sql: ${TABLE}."SALE_PRICE" ;;
    value_format_name: usd_0
  }

  measure: total_shipping {
    type: sum_distinct
    sql_distinct_key:  ${TABLE}."ORDER_ID"  ;;
    sql: ${TABLE}."SALE_PRICE" ;;
  }

  measure: total_sales {
    type: sum
    drill_fields: [detail*]
    sql: ${TABLE}.sale_price ;;
    value_format_name: usd_0
  }

  measure: min_sales {
    type: min
    drill_fields: [detail*]
    sql: ${TABLE}.sale_price ;;
    value_format_name: usd_0
  }
  measure: max_sales {
    type: max
    drill_fields: [detail*]
    sql:${TABLE}.sale_price ;;
    value_format_name: usd_0
  }
  measure: avg_sales {
    type: average
    drill_fields: [detail*]
    sql: ${TABLE}.sale_price ;;
    value_format_name: usd_0
  }

  dimension_group: shipped {
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
    sql: ${TABLE}."SHIPPED_AT" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: is_pending {
    type: yesno
    sql: ${status}='Pending' ;;
  }

  dimension: is_returned {
    type: yesno
    sql: ${status}='Returned' ;;
  }

  dimension: is_complete {
    type: yesno
    sql: ${status}='Completed' ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
    html: <span title="Orders Count:">{{rendered_value}}</span>;;
  }

  measure: count_orders {
    label: "Order Count"
    description: "Distinct Orders Count with Drill fields"
    type: count_distinct
    drill_fields: [detail*]
    sql: ${TABLE}.order_id ;;
    html: <span title="Orders Count:">{{rendered_value}}</span>;;
  }

  measure: gross_margin {
    label: "Gross Margin"
    description: "Gross Margin = Sales Price - Inventory Items Cost"
    type: number
    drill_fields: [detail*]
    sql: ${sales}-${inventory_items.cost} ;;
    value_format_name: usd_0
  }

  measure: total_gross_margin {
    type: number
    drill_fields: [detail*]
    sql: ${total_sales}-${inventory_items.total_cost} ;;
    value_format_name: usd_0
  }

  measure: prev_month_sale {
    label: "Previous Month Total Sale"
    description: "Previous Month Total Sale with drill fields"
    type:  sum
    sql: ${TABLE}.sale_price ;;
    drill_fields: [detail*]
    filters:
    {
      field: created_month
      value: "last month"}
    value_format_name: usd_0
  }

  measure: total_returned_price  {
    label: "Total Returned Price"
    description: "Returned Price with filter is_returned = YES"
    type: sum
    sql: ${TABLE}.sale_price;;
    drill_fields: [detail*]
    filters: {field: is_returned
      value: "YES"}
    value_format_name: usd_0
  }


  measure: completed_orders_percent {
    type: number
    sql:(${completed_orders})/ nullif(${count_orders},0) ;;
    value_format_name: percent_1
  }

  measure: completed_orders {
    type: count_distinct

    sql: ${TABLE}.order_id ;;
    filters: {
      field: status
      value: "Complete"
    }
  }

  measure: sale_by_gender {
    type: sum
    sql: ${TABLE}.sale_price;;
    filters: {
      field: users.gender
      value: "Male"
    }
    filters: {
      field: users.gender
      value: "Female"
    }
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.id,
      users.first_name,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
