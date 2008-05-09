class Answer < ActiveRecord::Base
  belongs_to :user
  has_many :messages
  
  def note_to_mail
    case self.quest_id
    when 1
      notas = self.note5
    when 4
      notas = self.note2
    else
      notas = self.note1
    end
  end

end
