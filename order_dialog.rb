$:.unshift File.join( File.dirname( __FILE__ ), "lib" )

require 'product_helper'
require 'customer_helper'
require 'subproducts_dialog'
require 'order_items_dialog'

class OrderDialog

  def initialize( app, products, customers, orders )
    @app = app
    @orders = orders
    @products = products
    @customers = customers
    @product_names = ProductHelper.names(products)
    @customer_names = CustomerHelper.names(customers)

    @app.flow :margin => 4 do
      @app.border "#CD9"

      # This stack is 230 pixels wide
      # width needed to create 2 columns. See http://shoesrb.com/manual/Rules.html
      @app.stack :margin => 4, :width => 260 do
        @app.border "#CD9"

        @app.para "Data:", :stroke => "#CD9", :margin => 4
        @gui_date = @app.edit_line :margin => 4
        @gui_date.text = Date.today.to_s

        @app.para "Client:", :stroke => "#CD9", :margin => 4
        @gui_customer_name_selected = @app.list_box items: @customer_names, :margin => 4 do |list|
          customer = CustomerHelper.find_customer_with_name( @customers, list.text)
          @order_items_dialog.customer = customer
        end

        @app.button "Crear comanda", :margin => 10 do
          if @order_items_dialog.ordered_items.empty?
            alert "Ha de afegir un producte per poder realitzar una comanda."
          else
            add_order( @gui_customer_name_selected.text, @order_items_dialog.ordered_items, @gui_date.text )
            alert "Comanda afegida!"
            @order_items_dialog.clear
            # TODO Move this to @order_items_dialog
            @gui_order_view.clear
            debug( "Order for #{@gui_customer_name_selected.text} added." )
          end
        end

      end

      # @gui_text_order_items is a stack 100% minus 230 pixels wide
      @gui_order_view = @app.stack :margin => 4, :width => -260 do
        @app.border "#CD9"
      end

      @order_items_dialog = OrderItemsDialog.new( @app, @products, @gui_order_view )
      @order_items_dialog.draw

    end
  end

  private

  def add_order(customer_name, order_items, date_string )
    customer = CustomerHelper.find_customer_with_name( @customers, customer_name )
    @orders << Order.new( customer, order_items, date_string )
  end

  def print_product_name(name)
    # http://stackoverflow.com/questions/14714936/fix-ruby-string-to-n-characters
    @app.para "kg #{'%-25.25s' % name}", :stroke => "#CD9", :width => -50
  end

end