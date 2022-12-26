import pandas as pd
import tensorflow as tf
from tf import keras


data = pd.read_csv("C:/Users/jvjos/Desktop/System/Data/2020 manufacturing.csv", header=0)
x = data.iloc[:, [0,2]]
DateTime = pd.to_datetime(x['Day'] + ' ' + x['Hour'])
x.loc['Day'] = DateTime
x.drop("Hour", 1, inplace = True)
y = data.iloc[:, 4]