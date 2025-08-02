# Precipitation Forecasting in Bear Island

This repository contains the code and data used in the paper: **"Forecasting Precipitation in Bear Island using Probabilistic Machine Learning Informed by Causal Climate Drivers"**

## Paper Summary

We propose a comprehensive framework that identifies the causal drivers of precipitation levels in the Arctic and develops a probabilistic machine learning approach to forecast weekly precipitation dynamics. The model incorporates key climate drivers, including temperature, humidity, air pressure, and cloud cover. By integrating causal analysis with data-driven, uncertainty-aware forecasting models, our framework effectively addresses challenges such as data sparsity and nonlinear variability inherent in Arctic precipitation patterns.

## Repository Structure

- `Dataset/`: Processed weekly dataset for Bear Island. Daily observations are collected from [Source](https://seklima.met.no/).
- `Codes/Preliminary Analysis/`: Notebooks for determining global features of the atmospheric variables
- `Codes/Causality/`: Scripts for identifying causal climatic drivers via wavelet coherence analysis and Synergistic-Unique-Redundant Decomposition (SURD) approach
- `Codes/Forecasting/`: Notebooks for implementing data-driven forecasting models with and without causal drivers  

## Quick Start

```bash
git clone https://github.com/mad-stat/Precipitation_Forecasting.git
cd Precipitation_Forecasting

