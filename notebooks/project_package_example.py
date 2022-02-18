# ---
# jupyter:
#   jupytext:
#     cell_metadata_filter: -hide_output
#     notebook_metadata_filter: all,-widgets,-varInspector
#     text_representation:
#       extension: .py
#       format_name: percent
#       format_version: '1.3'
#       jupytext_version: 1.13.7
#   language_info:
#     name: python
# ---

# %% [markdown]
# # Example using `projectname` package

# %%
from projectname.datasets import process_data
from projectname.visualisation import heatmap

# %%
process_data("input_data.csv", "output_data.csv")

# %%
heatmap("data_file.csv", "./results/figure/heatmap.png")
