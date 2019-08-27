class InvoicesCollection < BaseCollection
  def meta
    return { products: results, total_pages: total_pages } if params[:by_product].present?
    return { total_count: total_count, total: total, selected_products: results, total_pages: total_pages } if params[:by_selected_products].present?
    return { results: results } if params[:last_week_sales].present?
    { total_count: total_count, total: total, invoices: results, total_pages: total_pages }
  end

  private

  def total_count
    return results.offset(0).sum("sold_items.quantity") if params[:by_selected_products].present?
    results.count
  end

  def total
    return results.offset(0).sum("sold_items.quantity * sold_items.unit_price") if params[:by_selected_products].present?
    results.offset(0).sum(:total)
  end

  def total_pages
    results.total_pages if params["page"].present?
  end

  def relation
    return @relation ||= SoldItem.joins(:item).where("sold_items.item_id IN (#{params[:by_selected_products]})").select("sold_items.*,items.name") if params[:by_selected_products].present?
    @relation ||= Invoice.all
  end

  def ensure_filters
    today_filter
    date_filter
    product_filter
    last_week_sales_filter
  end

  def today_filter
    filter {|relation| relation.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)} if params[:today].present?
  end

  def date_filter
    filter {|relation| relation.where("#{params[:by_selected_products].present? ? "sold_items" : "invoices"}.created_at BETWEEN ? AND ?",Date.parse(params[:from_date]).beginning_of_day,Date.parse(params[:to_date]).end_of_day)} if params[:from_date].present? && params[:to_date].present?
  end

  def product_filter
    filter {|relation| relation.joins(sold_items: :item).select('"items"."id", "items"."name", SUM("sold_items"."quantity") as "quantity", SUM ("sold_items"."unit_price"*"sold_items"."quantity") as "total_sold_price"').group('"items"."id"')} if params[:by_product].present?
  end

  def last_week_sales_filter
    filter {|relation| relation.where(created_at: 1.week.ago.beginning_of_week..1.week.ago.end_of_week).select("sum(total) as total, created_at ::date").group("created_at::date")} if params[:last_week_sales].present?
  end

end