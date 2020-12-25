#!/bin/bash
sudo kill -9 $(ps aux | grep peppymeter | grep root | awk '{ print $2 }')
