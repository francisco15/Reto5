#!/usr/bin/env ruby
require 'csv'

class Question
  attr_reader :definition, :answer

  def initialize(definition, answer)
    @definition = definition
    @answer = answer
  end

  def is_valid?(answer)
    self.answer == answer.downcase.strip
  end

  def to_s
    self.definition
  end
end

class StoreQuestion
  attr_reader :questions

  def initialize
    @questions = []

    build_questions
  end

  def take!
    @questions.shift
  end

  def length
    @questions.length
  end

  private
    def build_questions
      store = CSV.read('questions.txt').shuffle
      
      store.each do |question|
        @questions << Question.new(question[0],question[1])
      end
    end
end

class Reto5
  attr_reader :store_question

  def initialize(store_question)
    @store_question = store_question
  end

  def start
    puts "\n\tWelcome to RETO 5, A list of questions about Ruby programming you can use to quiz yourself.",
         "\n\tTo start playing, just enter the correct answer for each of the questions, Ready? Let's go!"

    good_points = 0
    bad_points = 0

    number_of_questions = @store_question.length
    question = @store_question.take!
    while question != nil  && bad_points < number_of_questions*0.5
      print "\n\tQuestion: #{question} "  
      answer = gets.chomp

      if question.is_valid?(answer)
        good_points += 1
        puts "\n\tRight!!!"
        question = @store_question.take!
      else
        bad_points += 1
        puts "\n\tWrong!, Try again"
      end
    end
    
    puts good_points == number_of_questions ? "\n\tCongratulations #{good_points}/#{number_of_questions} !!" : "\n\tKeep trying #{good_points}/#{number_of_questions}, You will achieve it"
  end
end

reto_5 = Reto5.new(StoreQuestion.new)
reto_5.start
