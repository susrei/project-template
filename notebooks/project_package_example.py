# ---
# jupyter:
#   interpreter:
#     hash: 949777d72b0d2535278d3dc13498b2535136f6dfe0678499012e853ee9abcab1
#   jupytext:
#     cell_metadata_filter: -hide_output
#     notebook_metadata_filter: all,-widgets,-varInspector
#     text_representation:
#       extension: .py
#       format_name: percent
#       format_version: '1.3'
#       jupytext_version: 1.13.7
#   kernelspec:
#     display_name: Python 3.9.10 64-bit
#     language: python
#     name: python3
#   language_info:
#     codemirror_mode:
#       name: ipython
#       version: 3
#     file_extension: .py
#     mimetype: text/x-python
#     name: python
#     nbconvert_exporter: python
#     pygments_lexer: ipython3
#     version: 3.9.10
# ---

# %% [markdown]
# # Example using `projectname` package
#
# ## Load packages

# %%
from projectname.datasets import process_data
from projectname.visualisation import heatmap

# %% [markdown]
# ## Call imported packages

# %%
process_data("input_data.csv", "output_data.csv")

# %%
heatmap("data_file.csv", "./results/figure/heatmap.png")

# %% [markdown]
# ## Do more stuff

# %%
print("Hello, World!")

# %%
