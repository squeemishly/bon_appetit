require './lib/recipe'
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'

class RecipeTest < Minitest::Test
  attr_reader :r

  def setup
    @r = Recipe.new("Cheese Pizza")
  end

  def test_it_has_a_name
    assert_equal "Cheese Pizza", r.name
  end

  def test_it_can_add_an_ingredient
    r.add_ingredient("Flour", 500) # 500 "UNIVERSAL UNITS"
    assert_equal ["Flour"], r.ingredient_types
    r.add_ingredient("Cheese", 1500)
    assert_equal ["Flour", "Cheese"], r.ingredient_types
  end

  def test_it_tracks_amount_of_a_recipe_required
    r.add_ingredient("Flour", 500)
    assert_equal 500, r.amount_required("Flour")
  end

  def test_it_can_find_a_whole_lest_of_ingredients
    r.add_ingredient("Cheese", 20)
    r.add_ingredient("Flour", 20)
    assert_equal ["Cheese", "Flour"], r.ingredients.keys
    assert_equal [20, 20], r.ingredients.values
  end
end

# pantry = Pantry.new
# # => <Pantry...>
#
# # Building our recipe
# r = Recipe.new("Cheese Pizza")
# # => <Recipe...>
#
# r.ingredients
# # => {}
#
# r.add_ingredient("Cheese", 20)
# r.add_ingredient("Flour", 20)
#
# r.ingredients
# # => {"Cheese" => 20, "Flour" => 20}
#
# # Adding the recipe to the shopping list
# pantry.add_to_shopping_list(r)
#
# # Checking the shopping list
# pantry.shopping_list # => {"Cheese" => 20, "Flour" => 20}
#
# # Adding another recipe
# r = Recipe.new("Spaghetti")
# r.add_ingredient("Noodles", 10)
# r.add_ingredient("Sauce", 10)
# r.add_ingredient("Cheese", 5)
# pantry.add_to_shopping_list(r)
#
# # Checking the shopping list
# pantry.shopping_list # => {"Cheese" => 25, "Flour" => 20, "Noodles" => 10, "Sauce" => 10}
#
# # Printing the shopping list
# pantry.print_shopping_list
# # * Cheese: 25
# # * Flour: 20
# # * Noodles: 10
# # * Sauce: 10
# # => "* Cheese: 20\n* Flour: 20\n* Spaghetti Noodles: 10\n* Marinara Sauce: 10"
