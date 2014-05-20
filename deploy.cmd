@echo off

:: ----------------------
:: KUDU Deployment Script
:: ----------------------

:: Setup
:: -----

setlocal enabledelayedexpansion

SET ARTIFACTS=%~dp0%artifacts

IF NOT DEFINED DEPLOYMENT_SOURCE (
  SET DEPLOYMENT_SOURCE=%~dp0%.
)

IF NOT DEFINED DEPLOYMENT_TARGET (
  SET DEPLOYMENT_TARGET=%ARTIFACTS%\wwwroot
)

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Deployment
:: ----------

:: 3. Build Snow Site
echo -----
echo Start - Building the Snow Site