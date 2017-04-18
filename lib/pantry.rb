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

  #I should use find_all, but I don't have time to troubleshoot the problem I'm having
  def what_can_i_make
    recipes = []
    cookbook.each do |recipe, ingredients|
      if ingredients.all? { |i| i[1] <= stock[i[0]] }
      recipes << recipe
      end
    end
    recipes
  end

  def how_many_can_i_make
    times_i_can_make_it = Hash.new(0)
    what_can_i_make.each do |recipe|
      ingreds = cookbook[recipe]
      ingreds.each do |key, value|
        binding.pry
      end
    end
  end

end
