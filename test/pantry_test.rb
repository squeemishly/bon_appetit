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

end
