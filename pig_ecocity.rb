# See shoes examples expert-funnies.rb

$:.unshift File.join( File.dirname( __FILE__ ), "lib" )

require 'product_csv'
require 'customers_csv'
require 'customer_helper'
require 'product_helper'
require 'order'
require 'order_item'
require 'pig'
require 'order_dialog'
require 'resume_dialog'

require 'products_view'
require 'orders_view'
require 'customers_view'
require 'new_order_view'

def products_csv__path
  return ::File.join( File.dirname( __FILE__ ), "csv/products.csv" )
end

def customers_csv__path
  return ::File.join( File.dirname( __FILE__ ), "csv/customers.csv" )
end

def load_products
  debug( "Loading Products ..." )
  begin
    ProductCSV.read( products_csv__path )
  rescue Errors::ProductCSVError => e
    alert e.message
  end
end

def load_customers
  debug( "Loading Customers ..." )
  begin
    CustomerCSV.read( customers_csv__path )
  rescue Errors::CustomersCSVError => e
    alert e.message
  end
end

Shoes.app :width => 1000, :height => 900 do
  background "#555"

  @title = "Ecocity Porc"

  stack :margin => 10 do
    title strong(@title), :align => "center", :stroke => "#DFA", :margin => 0

    @products = load_products
    @customers = load_customers
    @orders = []
    @pig = Pig.new

    @product_names = ProductHelper.names(@products)
    @customer_names = CustomerHelper.names(@customers)

    flow :margin => 10 do
      button "Productes", :margin => 4 do
        @gui_main_window.clear{
          ProductsView.new(self, @products)
        }
      end

      button "Comandes", :margin => 4 do
        @gui_main_window.clear{
          OrdersView.new(self, @orders)
        }
      end

      button "Clients", :margin => 4 do
        @gui_main_window.clear{
          CustomersView.new( self, @customers)
        }
      end

      button "Nova Comanda", :margin => 4 do
        @gui_main_window.clear{
          stack :margin => 4, :width => 260 do
            border "#CD9"
            para "Data:", :stroke => "#CD9", :margin => 4
            date = edit_line "#{Date.today.to_s}", :margin => 4

            para "Client:", :stroke => "#CD9", :margin => 4
            customer_name = list_box items: @customer_names, :margin => 4

            button "Acceptar", :margin => 4 do
              begin
                customer = CustomerHelper.find_customer_with_name( @customers, customer_name.text)
              rescue Errors::CustomerHelperError
                alert "Selecciona un client"
                return
              end
              @gui_main_window.clear{ NewOrderView.new(self, @products, customer, date ) }
            end
          end
        }
      end

      button "TOTAL", :margin => 4 do
        @gui_main_window.clear{
          ResumeDialog.new( self, @orders, @pig, @products )
        }
      end

      # This is for clearing flow when user press any button
      # extracted from here http://ruby.about.com/od/shoes/ss/shoes3_2.htm
      @gui_main_window = flow
    end

  end
end