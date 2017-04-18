require './lib/recipe'
require 'pry'

class Pantry
  attr_reader :stock,
              :shopping_list,
              :cookbook

  def initialize
    @stock = Hash.new(0)
    @shopping_list = Hash.new(0)
    @cookbook = Hash.new(0)
  end

  def stock_check(item)
    stock[item]
  end

  def restock(item, quantity)
    stock[item] += quantity
  end

  def add_to_shopping_list(recipe)
    recipe.ingredients.each do |key, value|
      shopping_list[key] += value
    end
  end

  def print_shopping_list
    to_print = ""
    shopping_list.each do |key, value|
      to_print += "* #{key}: #{value}\n"
    end
    to_print.chomp
  end

  def add_to_cookbook(recipe)
    cookbook[recipe.name] = recipe.ingredients
  end

  def what_can_i_make
    cookbook.each do |recipe, ingredients|
      ingredients.each do |ingredient, quantity|
        if stock[ingredient] >= quantity
          binding.pry
        end
      end
    end
  end

end
