require 'product'
require 'customer'

class OrderItem
  attr_reader :product
  attr_reader :quantity
  attr_reader :weight
  attr_reader :observations
  attr_reader :price
  attr_reader :sub_products  # Only for lots (A list of SubProduct objects)

  def initialize(customer, product, quantity, weight, observations, sub_products)
    @product = product
    @quantity = quantity
    @weight = weight
    @observations = observations
    @price = calculate_price(customer.type)
    @sub_products = sub_products.dup
  end

  def to_s
    get_item_string + get_observations_string + get_subproducts_string
  end

  def has_observations?
    if @observations.empty?
      false
    else
      true
    end
  end

  private

  def calculate_price(customer_type)
    raise "Wrong customer type found" unless customer_type =~ /CLIENT|COOPE|TIENDA/

    if @product.has_subproducts?
      calculate_price_based_on_units(customer_type)
    else
      calculate_price_based_on_weight(customer_type)
    end

  end

  def calculate_price_based_on_weight(customer_type)
    total = 0
    case customer_type
      when "CLIENT"
        total += @quantity * @weight.to_f * @product.price_pvp.to_f
      when "COOPE"
        total += @quantity * @weight.to_f * @product.price_coope.to_f
      when "TIENDA"
        total += @quantity * @weight.to_f * @product.price_tienda.to_f
      else
        total += 0
    end

    total
  end

  def calculate_price_based_on_units(customer_type)
    total = 0
    case customer_type
      when "CLIENT"
        total += @quantity * @product.price_pvp.to_f
      when "COOPE"
        total += @quantity * @product.price_coope.to_f
      when "TIENDA"
        total += @quantity * @product.price_tienda.to_f
      else
        total += 0
    end

    total
  end

  def get_observations_string
    if has_observations?
      "\nObservacions: #{@observations.to_s}"
    else
      " "
    end
  end

  def get_item_string
    if @weight.to_f == 0.0
      "#{@quantity.to_i} x #{@product.name} = #{'%.2f' % @price.to_f} EUR"
    else
      "#{@quantity.to_i} x #{'%.3f' % @weight.to_f} kg #{@product.name} = #{'%.2f' % @price.to_f} EUR"
    end
  end

  def get_subproducts_string
    sub_string = ""
    if !@sub_products.empty?
      @sub_products.each do |subproduct|
        sub_string += "\n\t#{subproduct.quantity} x #{subproduct.weight} kg #{subproduct.name}"
      end
    end

    sub_string
  end

end