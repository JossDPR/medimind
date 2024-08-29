class TutorPatientsController < ApplicationController
  def show
    @relation = TutorPatient.find(params[:id])
    @chat= Chat.new
    if current_user.tutor?
      @other_user = @relation.patient
      @writer=current_user
    else
      @writer = current_user
      @other_user=@relation.tutor
    end
  end
end
