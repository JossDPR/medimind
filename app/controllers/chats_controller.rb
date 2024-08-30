class ChatsController < ApplicationController

  def create
    @relation = TutorPatient.find(params[:tutor_patient_id])
    @chat = Chat.new(chat_params)
    @chat.tutor_patient = @relation
    @chat.user = current_user
    @chat.read = false
    if @chat.save!
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append(:chats, partial: "components/chat",
            locals: { chat: @chat, user: current_user })
        end
        format.html { redirect_to tutor_patient_path(@relation) }
      end
    else
      render "tutor_patient/show", status: :unprocessable_entity
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:message, :tutor_patient, :user, :read)
  end
end
