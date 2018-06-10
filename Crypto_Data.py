import requests
import requests
import datetime
import pandas as pd


url = 'https://min-api.cryptocompare.com/data/histohour' +\
        '?fsym=ETH' +\
        '&tsym=USD' +\
        '&limit=4000' +\
        '&aggregate=1'
response = requests.get(url)
data = response.json()['Data']

import pandas as pd
df = pd.DataFrame(data)
df['Crypto'] = 'ETH'
df['timestamp'] = [datetime.datetime.fromtimestamp(d) for d in df.time]
#print(df)

url = 'https://min-api.cryptocompare.com/data/histohour' +\
        '?fsym=BTC' +\
        '&tsym=USD' +\
        '&limit=4000' +\
        '&aggregate=1'
response = requests.get(url)
data = response.json()['Data']

import pandas as pd
df1 = pd.DataFrame(data)
df1['Crypto'] = 'BTC'
df1['timestamp'] = [datetime.datetime.fromtimestamp(d) for d in df.time]
df1=df1.append(df)

url = 'https://min-api.cryptocompare.com/data/histohour' +\
        '?fsym=XRP' +\
        '&tsym=USD' +\
        '&limit=4000' +\
        '&aggregate=1'
response = requests.get(url)
data = response.json()['Data']

import pandas as pd
df2 = pd.DataFrame(data)
df2['Crypto'] = 'XRP'
df2['timestamp'] = [datetime.datetime.fromtimestamp(d) for d in df.time]
df2=df2.append(df1)




df2.to_csv("Crypto.csv", sep=',', encoding='utf-8',index=None)