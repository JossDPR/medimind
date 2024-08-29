class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :tutor_patient

  after_create_commit :broadcast_message

  private

  def broadcast_message
    broadcast_append_to "chat_#{tutor_patient.id}_chats",
                        partial: "components/chat",
                        locals: { chat:self, user:user },
                        target: "chats"
  end
end
