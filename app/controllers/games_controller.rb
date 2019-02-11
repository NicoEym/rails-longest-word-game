require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']
    @letters = []
    10.times do
      @letters << alphabet.sample
    end
    @letters
  end

  def score
    @word = params[:word].upcase
    @list_of_letters = params[:letters].gsub(/\W/, '').chars
    @score = run_game(@word, @list_of_letters)
  end

  def string_to_frequency_hash(string)
  frequencies = Hash.new(0)
  symbols = string.downcase.chars.map { |letter| letter.to_sym }
  symbols.each { |symbol| frequencies[symbol] += 1 }
  frequencies
  end

  def sc_cal(attempt, grid)
    result_array = []
    grid = grid.join("")
    grid_hash = string_to_frequency_hash(grid)
    attempt_hash = string_to_frequency_hash(attempt)

    attempt_hash.map do |k, _v|
      grid_hash.key?(k) == true && grid_hash[k] >= attempt_hash[k] ? result_array << true : result_array << false
    end
    result_array
  end

  def run_game(attempt, grid)
  # TODO: runs the game and return detailed hash of result
  url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
  user_serialized = open(url).read
  user = JSON.parse(user_serialized)

  return { score: "0".to_i, attempt: attempt, grid: grid } if user["found"] == false

  return { score: "-1".to_i, attempt: attempt, grid: grid } if sc_cal(attempt, grid).include? false

  return { score: sc_cal(attempt, grid).count { |res| res == true }, attempt: attempt, grid: grid }
  end
end
