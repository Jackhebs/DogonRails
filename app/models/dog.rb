# frozen_string_literal: true

class Dog < ApplicationRecord
  has_one_attached :image
  has_many :dog_foods, dependent: :destroy
  scope :dog_by_name, -> { order('LOWER(name) ASC') }
  scope :dog_searched, -> { where(name: name.downcase)}
  #scope :name_includes, -> (name){ where(name: name)}
  dogs_name = Dog.arel_table[:name]
  scope :name_includes, -> (name){ where(dogs_name.matches("%" + name + "%"))}
  accepts_nested_attributes_for :dog_foods, allow_destroy: true





  validates :name,
            presence: true,
            format: { with: /\A[a-zA-Z]+\z/, message: 'only allows letters' },
            length: { minimum: 3, message:'Dog name must be - minimum 3, maximum 10', maximum: 10,},
            uniqueness: { case_sensitive: false }
  validates :weight,
            presence: true,
            numericality: { greater_than: 0, less_than: 161 }
  validates :birthdate,
            presence: true

  def information; end

  def age
    months = ((Time.current - birthdate) / (60 * 60 * 24 * 30)).to_i

    {
      years: (months / 12).to_i,
      months: (months % 12)
    }
  end

  def all_dog_foods
    res = []
    Food.find_each do |food|
      res << DogFood.find_or_initialize_by(food: food, dog: self)
    end
    res
  end
end
