#!/bin/bash
sudo named-checkconf;
sudo systemctl reload bind9;
systemctl status bind9;