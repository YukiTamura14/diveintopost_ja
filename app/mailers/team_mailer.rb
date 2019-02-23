class TeamMailer < ApplicationMailer
  def team_mail(email, team)
    @email = email
    @team = team
    mail to: @email, subject: "#{@team.name}のチームリーダになりました！"
  end
end
