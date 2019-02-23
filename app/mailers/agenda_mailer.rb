class AgendaMailer < ApplicationMailer
  def agenda_mail(agenda, team, email)
     @agenda = agenda
     @team = team
     @email = email
     mail to: @email, subject: 'アジェンダが削除されました。'
   end
end
