#!/bin/sh

scp -r html pushl:
ssh pushl "sudo rm -rf /var/www/compro ; sudo mv html /var/www/compro"

