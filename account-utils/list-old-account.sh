#!/bin/bash

DAYS=${1:-360}

lastlog -b "$DAYS" -u 1000-
