import pandas as pd
import plotly.express as px
import numpy as np
from bs4 import BeautifulSoup
import requests


r = requests.get('https://officialguide.lsac.org/release/Search/RegionList.aspx',
                 headers={"User-Agent": "Mozilla/5.0"})
content = BeautifulSoup(r.content, 'html.parser')

regions = [region.get_text().strip().strip('\\r\\n')
           for region in content.find_all('h2', {'class': 'region'})]

states = [state.get_text().strip().strip('\\r\\n').strip().split(',')
          for state in content.find_all('p', {'class': 'states'})]
states = [[st.strip('\\r\\n').strip() for st in state] for state in states]
states[1][5] = "Wisconsin"

states[7][0]="Oregon"
states[7][1]="Washington"
print(states)

region_map={}
for state,region in zip(states,regions):
    region_map[region]=state


def get_region(state, map = region_map):
    for region in map.keys():
        if state in map[region]:
            return region
    return state

df=pd.read_csv('/Users/siddharthsurapaneni/bootcamp/bootcamp/us-counties.csv')
df['region']=[get_region(state) for state in df['state']]

new_df=(df.groupby(['region','date'])['cases'].sum().reset_index())
#print(pd.DataFrame(np.array(new_df.index).reshape(2082, 2),columns=["region","date"]))
fig=px.line(new_df, x='date',y='cases',color='region')
fig.show()