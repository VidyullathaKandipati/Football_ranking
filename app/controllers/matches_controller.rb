class MatchesController < ApplicationController
  before_action :set_match, only: [:show, :edit, :update, :destroy]

  # GET /matches
  # GET /matches.json
  def index
    @matches = Match.all
  end

  def stats
    teams1 = Match.uniq.pluck(:team1)
    teams2 = Match.uniq.pluck(:team2)
    @teams = teams1 | teams2
    print "%%%%%%%"
    print @teams
    @winRate = Hash.new
    @lossRate = Hash.new
    @error = nil

    @teams.each do |team|
      wins = Match.where(:winner => team).count.to_f
      loses = Match.where(:loser => team).count.to_f
      totalMatches = wins + loses
      @winRate[team] = (wins / totalMatches) * 100
      @lossRate[team] = (loses / totalMatches) * 100
      print "totalMatches: ", totalMatches
      print "winRate: ", @winRate
      print "lossRate: ", @lossRate
    end

    if params[:input1] and params[:input2]
      @team1 = params[:input1]
      @team2 = params[:input2]
      # Team 1 details
      team1Wins = Match.where("winner ILIKE ?", @team1.downcase).count.to_f
      team1Loses = Match.where("loser ILIKE ?", @team1.downcase).count.to_f
      team1TotalMatches = team1Wins + team1Loses

      # Team 2 details
      team2Wins = Match.where("winner ILIKE ?", @team2.downcase).count.to_f
      team2Loses = Match.where("loser ILIKE ?", @team2.downcase).count.to_f
      team2TotalMatches = team2Wins + team2Loses

      if team1TotalMatches == 0 or team2TotalMatches == 0
        @error = "Invalid input"
      else
        @compareWinRate = team2Wins == 0 ? 100 : (team1Wins / team2Wins) * 100;
        @compareLossRate = team2Loses == 0 ? 100 : (team1Loses / team2Loses) * 100;
        print @compareWinRate, @compareLossRate
      end
    end
  end

  # GET /matches/1
  # GET /matches/1.json
  def show
  end

  # GET /matches/new
  def new
    @match = Match.new
  end

  # GET /matches/1/edit
  def edit
  end

  # POST /matches
  # POST /matches.json
  def create
    @match = Match.new(match_params)

    respond_to do |format|
      if @match.save
        format.html { redirect_to @match, notice: 'Match was successfully created.' }
        format.json { render :show, status: :created, location: @match }
      else
        format.html { render :new }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matches/1
  # PATCH/PUT /matches/1.json
  def update
    respond_to do |format|
      if @match.update(match_params)
        format.html { redirect_to @match, notice: 'Match was successfully updated.' }
        format.json { render :show, status: :ok, location: @match }
      else
        format.html { render :edit }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1
  # DELETE /matches/1.json
  def destroy
    @match.destroy
    respond_to do |format|
      format.html { redirect_to matches_url, notice: 'Match was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_match
      @match = Match.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def match_params
      params.require(:match).permit(:name, :team1, :team2, :winner, :loser)
    end
end
