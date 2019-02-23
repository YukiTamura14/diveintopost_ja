class AgendasController < ApplicationController
  before_action :set_agenda, only: %i[show edit update destroy]

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: 'アジェンダ作成に成功しました！'
    else
      render :new
    end
  end

  def destroy
    if current_user == @agenda.user || current_user == @agenda.team.owner
      @agenda.team.members.each do |team_member|
        AgendaMailer.agenda_mail(@agenda, @agenda.team, team_member.email).deliver
      end
      @agenda.destroy
      redirect_to dashboard_url, notice: 'アジェンダを削除しました！'
    else
      redirect_to dashboard_url, notice: 'アジェンダを削除できるのは作成者かチームリーダーです、、'
    end
  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end
end
