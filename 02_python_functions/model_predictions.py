# Model Prediction for Placing Future Bets

import pandas as pd
import numpy as np 

## Model Selection  

model_name = input("model name: ")

init_path = '/Users/jordanwegner/Desktop/nba2/05_notebooks/01_models/01_model_outputs/'
predictions_path = init_path+model_name+'_full_predictions.csv'

fo = pd.read_csv(predictions_path)

ec_teams = ['Hornets',
 'Wizards',
 'Hawks',
 'Pacers',
 'Magic',
 'Pistons',
 'Raptors',
 'Knicks',
 'Bulls',
 'Cavaliers',
 'Nets',
 '76ers',
 'Heat',
 'Celtics',
 'Bucks']
wc_teams = ['Thunder',
 'Rockets',
 'Spurs',
 'Trail Blazers',
 'Kings',
 'Pelicans',
 'Grizzlies',
 'Timberwolves',
 'Jazz',
 'Warriors',
 'Mavericks',
 'Lakers',
 'Clippers',
 'Suns',
 'Nuggets']

ec = fo[fo['Team'].isin(ec_teams)]
wc = fo[fo['Team'].isin(wc_teams)]

print("Bet to Win EC: ")
ecb = ec.sort_values('Predicted Wins',ascending=False).head(4).reset_index(drop=True)
for i in ecb['Team']:
    print(i)
print('\n')
print("Bet to Win WC: ")
wcb = wc.sort_values('Predicted Wins',ascending=False).head(4).reset_index(drop=True)
for i in wcb['Team']:
    print(i)
print('\n')
print("Bet to Win NBA Finals: ")
fob = fo.sort_values('Predicted Wins',ascending=False).head(4).reset_index(drop=True)
for i in fob['Team']:
    print(i)
