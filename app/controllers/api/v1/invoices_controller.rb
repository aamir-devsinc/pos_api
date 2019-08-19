class Api::V1::InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_invoice, only: [:show]

  def index
    @invoices = Invoice.paginate(page: params[:page], per_page: 10)
    json = Invoice.paginate(page: params[:page], per_page: 10).to_json(:include => :sold_items)
    render json: {invoices: JSON.parse(json), total_pages: @invoices.total_pages}
  end

  def show
    render json:(@invoice.attributes.merge("sold_items": @invoices.sold_items))
  end

  def create
    @invoice = current_user.invoices.new(invoice_params)
    if @invoice.save
      render json:"invoice created successfully", status: :created
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end

  end

  private

    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    def all_invoices
      SoldItem.joins(:invoice)
    end

    def invoice_params
      params.require(:invoice).permit(:total, :adjustment, :discount_id, sold_items_attributes: [:item_id, :unit_price,:quantity, :discount])
    end
end
