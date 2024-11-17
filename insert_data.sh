#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
echo "$($PSQL "TRUNCATE teams,games RESTART IDENTITY")"
# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    #Found team_id
    winner_id="$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")"
    #If not found
    if [[ -z $winner_id ]]
    then
      $PSQL "INSERT INTO teams(name) VALUES('$WINNER');"
      winner_id="$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")"
    fi
    opponent_id="$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")"
    if [[ -z $opponent_id ]]
    then
      $PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');"
      opponent_id="$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")"
    fi
    #Found game_id
    game_insert="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $winner_id, $opponent_id, $WINNER_GOALS, $OPPONENT_GOALS);")"
    if [[ $game_insert = "INSERT 0 1" ]]
    then
    echo "Added to games"
    fi
  fi
done