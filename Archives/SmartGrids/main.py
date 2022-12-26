import numpy as np
import pandas as pd
from sklearn import svm
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
from sklearn.metrics import explained_variance_score
import datetime
from datetime import datetime
import numpy as np

data = pd.read_csv("C:/Users/jvjos/Desktop/System/Data/2020 manufacturing.csv", header=0)
x = data.iloc[:, [0,2]]
DateTime = pd.to_datetime(x['Day'] + ' ' + x['Hour'])
x.loc['Date-Time'] = DateTime
y = data.iloc[:, 4]

x_train, y_train, x_test, y_test = train_test_split(DateTime, y, test_size=0.2, shuffle=False)
model = svm.SVR()
x_train = np.ndarray(x_train)
model.fit(x_train.reshape, y_train)
y_pred = model.predict(x_test)

explained_variance_score(y_test, y_pred, multioutput = 'raw_values')

