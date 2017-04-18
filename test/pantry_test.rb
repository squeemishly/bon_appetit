require './lib/pantry'
require 'minitest/autorun'
require 'minitest/pride'

class PantryTest < Minitest::Test
  attr_reader :pantry,
              :r

  def setup
    @pantry = Pantry.new
  end

  def test_it_exists
    assert_instance_of Pantry, pantry
  end

  def test_it_can_access_its_supplies
    assert_instance_of Hash, pantry.stock
    assert_empty pantry.stock
  end

  def test_it_can_check_for_specific_items
    assert_equal 0, pantry.stock_check("Cheese")
  end

  def test_it_can_be_stocked_with_delicious_items
    assert_equal 0, pantry.stock_check("Cheese")
    pantry.restock("Cheese", 10)
    assert_equal 10, pantry.stock_check("Cheese")
    pantry.restock("Cheese", 20)
    assert_equal 30, pantry.stock_check("Cheese")
  end

  def test_it_can_stock_different_items
    assert_equal 0, pantry.stock_check("Cheese")
    assert_equal 0, pantry.stock_check("Olives")

    pantry.restock("Cheese", 10)
    assert_equal 10, pantry.stock_check("Cheese")
    assert_equal 0, pantry.stock_check("Olives")

    pantry.restock("Olives", 20)
    assert_equal 10, pantry.stock_check("Cheese")
    assert_equal 20, pantry.stock_check("Olives")
  end

  def test_it_builds_a_shopping_list
    r = Recipe.new("Cheese Pizza")
    r.add_ingredient("Cheese", 20)
    r.add_ingredient("Flour", 20)

    pantry.add_to_shopping_list(r)
    assert_equal ["Cheese", "Flour"], pantry.shopping_list.keys
    assert_equal [20, 20], pantry.shopping_list.values
  end

  def test_it_can_add_ingredients_from_multiple_recipes
    r = Recipe.new("Cheese Pizza")
    r.add_ingredient("Cheese", 20)
    r.add_ingredient("Flour", 20)

    pantry.add_to_shopping_list(r)
    assert_equal ["Cheese", "Flour"], pantry.shopping_list.keys
    assert_equal [20, 20], pantry.shopping_list.values

    r_two = Recipe.new("Spaghetti")
    r_two.add_ingredient("Noodles", 10)
    r_two.add_ingredient("Sauce", 10)
    r_two.add_ingredient("Cheese", 5)

    pantry.add_to_shopping_list(r_two)
    assert_equal ["Cheese", "Flour", "Noodles", "Sauce"], pantry.shopping_list.keys
    assert_equal [25, 20, 10, 10], pantry.shopping_list.values
  end

  def test_it_prints_the_shopping_list
    r = Recipe.new("Cheese Pizza")
    r.add_ingredient("Cheese", 20)
    r.add_ingredient("Flour", 20)

    r_two = Recipe.new("Spaghetti")
    r_two.add_ingredient("Noodles", 10)
    r_two.add_ingredient("Sauce", 10)
    r_two.add_ingredient("Cheese", 5)

    pantry.add_to_shopping_list(r)
    pantry.add_to_shopping_list(r_two)

    assert_equal "* Cheese: 25\n* Flour: 20\n* Noodles: 10\n* Sauce: 10", pantry.print_shopping_list
  end

  def test_we_can_create_a_cookbook
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)

    r2 = Recipe.new("Pickles")
    r2.add_ingredient("Brine", 10)
    r2.add_ingredient("Cucumbers", 30)

    r3 = Recipe.new("Peanuts")
    r3.add_ingredient("Raw nuts", 10)
    r3.add_ingredient("Salt", 10)

    pantry.add_to_cookbook(r1)
    pantry.add_to_cookbook(r2)
    pantry.add_to_cookbook(r3)

    assert_equal 3, pantry.cookbook.count
    assert_equal ["Cheese Pizza", "Pickles", "Peanuts"], pantry.cookbook.keys
    assert_equal [{"Cheese"=>20, "Flour"=>20}, {"Brine"=>10, "Cucumbers"=>30}, {"Raw nuts"=>10, "Salt"=>10}], pantry.cookbook.values
  end

  def test_it_can_suggest_recipes_based_on_ingredients_we_have_on_hand
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)

    r2 = Recipe.new("Pickles")
    r2.add_ingredient("Brine", 10)
    r2.add_ingredient("Cucumbers", 30)

    r3 = Recipe.new("Peanuts")
    r3.add_ingredient("Raw nuts", 10)
    r3.add_ingredient("Salt", 10)

    pantry.add_to_cookbook(r1)
    pantry.add_to_cookbook(r2)
    pantry.add_to_cookbook(r3)

    pantry.restock("Cheese", 10)
    pantry.restock("Flour", 20)
    pantry.restock("Brine", 40)
    pantry.restock("Cucumbers", 40)
    pantry.restock("Raw nuts", 20)
    pantry.restock("Salt", 20)

    assert_equal ["Pickles", "Peanuts"], pantry.what_can_i_make
  end

  def test_figure_out_how_many_we_can_make
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)

    r2 = Recipe.new("Pickles")
    r2.add_ingredient("Brine", 10)
    r2.add_ingredient("Cucumbers", 30)

    r3 = Recipe.new("Peanuts")
    r3.add_ingredient("Raw nuts", 10)
    r3.add_ingredient("Salt", 10)

    pantry.add_to_cookbook(r1)
    pantry.add_to_cookbook(r2)
    pantry.add_to_cookbook(r3)

    pantry.restock("Cheese", 10)
    pantry.restock("Flour", 20)
    pantry.restock("Brine", 40)
    pantry.restock("Cucumbers", 40)
    pantry.restock("Raw nuts", 20)
    pantry.restock("Salt", 20)

    assert_equal ["Pickles", "Peanuts"], pantry.what_can_i_make
    assert_equal ["Pickles", "Peanuts"], pantry.how_many_can_i_make.keys
    assert_equal [2, 1], pantry.how_many_can_i_make.values

  end

end


# pantry = Pantry.new
#
# # Building our recipe
# r1 = Recipe.new("Cheese Pizza")
# r1.add_ingredient("Cheese", 20)
# r1.add_ingredient("Flour", 20)
#
# r2 = Recipe.new("Pickles")
# r2.add_ingredient("Brine", 10)
# r2.add_ingredient("Cucumbers", 30)
#
# r3 = Recipe.new("Peanuts")
# r3.add_ingredient("Raw nuts", 10)
# r3.add_ingredient("Salt", 10)
#
#
# # Adding the recipe to the cookbook
# pantry.add_to_cookbook(r1)
# pantry.add_to_cookbook(r2)
# pantry.add_to_cookbook(r3)
#
# # Stock some ingredients
# pantry.restock("Cheese", 10)
# pantry.restock("Flour", 20)
# pantry.restock("Brine", 40)
# pantry.restock("Cucumbers", 40)
# pantry.restock("Raw nuts", 20)
# pantry.restock("Salt", 20)
#
# # What can I make?
# pantry.what_can_i_make # => ["Pickles", "Peanuts"]
#
# # How many can I make?
# pantry.how_many_can_i_make # => {"Brine Shot" => 4, "Peanuts" => 2}
