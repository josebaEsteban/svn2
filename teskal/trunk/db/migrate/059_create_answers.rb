class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
    end
  end

  def self.down
    drop_table :answers
  end
end
