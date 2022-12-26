import torch
import pytorch_forecasting
import pandas as pd
from pytorch_forecasting.data import (
    TimeSeriesDataSet,
    GroupNormalizer
)
import numpy as np
from pytorch_forecasting.data.examples import get_stallion_data
import calendar

from pytorch_forecasting.data.examples import get_stallion_data
data = pd.read_csv("C:/Users/jvjos/Desktop/System/Data/2020 manufacturing.csv", header=0)
# add time index
data['Day'] = pd.to_datetime(data['Day'])
data['time_idx'] = range(1, len(data)+1)
# add additional features
# categories have to be strings
data['Month'] = pd.to_datetime(data['Month'], format='%m').dt.month_name().str.slice()
data["Hour"] = data["Hour"].astype("string")
data["Hour"] = data["Hour"].astype("category")


max_prediction_length = 744  # forecast 1 months
max_encoder_length = 8039  # use 11 months of history
training_cutoff = data["time_idx"].max() - max_prediction_length

training = TimeSeriesDataSet(
    data[lambda x: x.time_idx <= training_cutoff+1],
    time_idx="time_idx",
    target="Total Manufacturing",
    min_encoder_length=0,  # allow predictions without history
    max_encoder_length=max_encoder_length,
    min_prediction_length=1,
    max_prediction_length=max_prediction_length,
    time_varying_known_categoricals=["Hour"],
    # group of categorical variables can be treated as
    # one variable
    time_varying_known_reals=[
        "time_idx",
    ],
    time_varying_unknown_categoricals=[],
    time_varying_unknown_reals=[
     "Total Manufacturing"
    ],
    add_relative_time_idx=True,  # add as feature
    add_target_scales=True,  # add as feature
    add_encoder_length=True,  # add as feature
    group_ids=["Hour"],
    allow_missing_timesteps=True
)

# create validation set (predict=True) which means to predict the
# last max_prediction_length points in time for each series
validation = TimeSeriesDataSet.from_dataset(
    training, data, predict=True, stop_randomization=True
)
# create dataloaders for model
batch_size = 64
train_dataloader = training.to_dataloader(
    train=True, batch_size=batch_size, num_workers=0
)
val_dataloader = validation.to_dataloader(
    train=False, batch_size=batch_size * 10, num_workers=0
)