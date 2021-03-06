# encoding: UTF-8

$:.unshift File.join( File.dirname( __FILE__ ), "lib" )

class CustomersView < Shoes::Widget
  def initialize( customers )
    stack :margin => 4 do
      headers
      customers.each do |customer|
        flow :margin => 4 do
          stack :width => '33%' do
            para "#{customer.name}", :margin => 4, :align => 'left'
          end
          stack :width => '33%' do
            para "#{customer.address}", :margin => 4, :align => 'right'
          end
          stack :width => '33%' do
            para "#{customer.nif}", :margin => 4, :align => 'right'
          end
        end
      end
    end
  end

  def headers
    flow :margin => 4 do
      border black
      stack :width => '33%' do
        para strong("NAME"), :margin => 4, :align => 'left'
      end
      stack :width => '33%' do
        para strong("ADDRESS"), :margin => 4, :align => 'right'
      end
      stack :width => '33%' do
        para strong("NIF"), :margin => 4, :align => 'right'
      end
    end
  end

end